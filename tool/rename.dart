import 'dart:io';

void main(List<String> args) {
  String? newName;
  String? newOrg;
  String? newDisplay;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--name' && i + 1 < args.length) {
      newName = args[++i];
    } else if (arg == '--org' && i + 1 < args.length) {
      newOrg = args[++i];
    } else if (arg == '--display' && i + 1 < args.length) {
      newDisplay = args[++i];
    }
  }

  if (newName == null) {
    stderr.writeln(
      'Usage: dart run tool/rename.dart --name <new_name> [--org <new_org>] [--display <"Display Name">]',
    );
    exit(1);
  }

  final validNameRegex = RegExp(r'^[a-z][a-z0-9_]*$');
  if (!validNameRegex.hasMatch(newName)) {
    stderr.writeln(
      'Error: --name must be a valid Dart package identifier (lowercase letters, numbers, and underscores).',
    );
    exit(1);
  }

  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stderr.writeln('Error: pubspec.yaml not found.');
    exit(1);
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final currentNameMatch = RegExp(
    r'^name:\s*([a-zA-Z0-9_]+)',
    multiLine: true,
  ).firstMatch(pubspecContent);
  if (currentNameMatch == null) {
    stderr.writeln(
      'Error: Could not find current package name in pubspec.yaml.',
    );
    exit(1);
  }
  final oldName = currentNameMatch.group(1)!;
  final org = newOrg ?? 'com.example';
  final display = newDisplay ?? _toTitleCase(newName);

  stdout.writeln('Renaming Flutter project:');
  stdout.writeln('  Package name: $oldName -> $newName');
  stdout.writeln('  Organization: $org');
  stdout.writeln('  Display name: $display');

  // 1. Update pubspec.yaml
  _replaceInFile(
    pubspecFile,
    RegExp(r'^name:\s*' + oldName, multiLine: true),
    'name: $newName',
  );

  // 2. Update imports in lib/, test/, and optional_modules/
  final dartDirs = [
    Directory('lib'),
    Directory('test'),
    Directory('optional_modules'),
  ];
  for (final dir in dartDirs) {
    if (!dir.existsSync()) continue;
    for (final file in dir.listSync(recursive: true).whereType<File>()) {
      if (file.path.endsWith('.dart')) {
        _replaceInFile(file, 'package:$oldName/', 'package:$newName/');
      }
    }
  }

  // 3. Update Android build.gradle.kts
  final gradleFile = File('android/app/build.gradle.kts');
  if (gradleFile.existsSync()) {
    var content = gradleFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'namespace\s*=\s*"[^"]+"'),
      'namespace = "$org.$newName"',
    );
    content = content.replaceAll(
      RegExp(r'applicationId\s*=\s*"[^"]+"'),
      'applicationId = "$org.$newName"',
    );
    content = content.replaceAll(
      RegExp(
        r'manifestPlaceholders\["appName"\]\s*=\s*"[^"]+"\s*//\s*default',
        multiLine: true,
      ),
      'manifestPlaceholders["appName"] = "$display"',
    );
    gradleFile.writeAsStringSync(content);
  }

  // 4. Update iOS project.pbxproj
  final pbxFile = File('ios/Runner.xcodeproj/project.pbxproj');
  if (pbxFile.existsSync()) {
    final camelName = _toCamelCase(newName);
    _replaceInFile(
      pbxFile,
      RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*[^;]+;'),
      'PRODUCT_BUNDLE_IDENTIFIER = $org.$camelName;',
    );
  }

  // 5. Update iOS Info.plist
  final plistFile = File('ios/Runner/Info.plist');
  if (plistFile.existsSync()) {
    var content = plistFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'<key>CFBundleDisplayName</key>\s*<string>[^<]+</string>'),
      '<key>CFBundleDisplayName</key>\n\t<string>$display</string>',
    );
    content = content.replaceAll(
      RegExp(r'<key>CFBundleName</key>\s*<string>[^<]+</string>'),
      '<key>CFBundleName</key>\n\t<string>$newName</string>',
    );
    plistFile.writeAsStringSync(content);
  }

  // 6. Update env files
  final envDir = Directory('env');
  if (envDir.existsSync()) {
    for (final file in envDir.listSync().whereType<File>()) {
      if (file.path.endsWith('.json')) {
        var content = file.readAsStringSync();
        content = content.replaceAll(
          RegExp(r'"APPLICATION_ID":\s*"[^"]+"'),
          '"APPLICATION_ID": "$org.$newName"',
        );
        file.writeAsStringSync(content);
      }
    }
  }

  // 7. Update l10n strings
  final enArb = File('l10n/app_en.arb');
  if (enArb.existsSync()) {
    _replaceInFile(
      enArb,
      RegExp(r'"appTitle":\s*"[^"]+"'),
      '"appTitle": "$display"',
    );
  }

  // 8. Auto-sort import directives for the new package name
  stdout.writeln('Sorting package import directives...');
  Process.runSync('dart', ['fix', '--apply']);

  stdout.writeln('🎉 Successfully renamed project to "$newName" ($display).');
  stdout.writeln('Next steps:');
  stdout.writeln('  1. flutter pub get');
  stdout.writeln(
    '  2. dart run build_runner build --delete-conflicting-outputs',
  );
  stdout.writeln('  3. flutter analyze');
}

void _replaceInFile(File file, Pattern pattern, String replacement) {
  if (!file.existsSync()) return;
  final content = file.readAsStringSync();
  final updated = content.replaceAll(pattern, replacement);
  if (content != updated) {
    file.writeAsStringSync(updated);
  }
}

String _toTitleCase(String input) {
  return input
      .split('_')
      .where((s) => s.isNotEmpty)
      .map((s) => s[0].toUpperCase() + s.substring(1))
      .join(' ');
}

String _toCamelCase(String input) {
  final parts = input.split('_').where((s) => s.isNotEmpty).toList();
  if (parts.isEmpty) return input;
  final first = parts.first.toLowerCase();
  final rest = parts
      .skip(1)
      .map((s) => s[0].toUpperCase() + s.substring(1).toLowerCase())
      .join('');
  return '$first$rest';
}
