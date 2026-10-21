import 'dart:io';

void main(List<String> args) {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Error: lib/ directory not found.');
    exit(1);
  }

  final violations = <String>[];

  final dartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where(
        (f) =>
            !f.path.endsWith('.g.dart') &&
            !f.path.endsWith('.freezed.dart') &&
            !f.path.endsWith('.config.dart'),
      )
      .toList();

  final printRegex = RegExp(r'\bprint\s*\(');
  final importRegex = RegExp(r'''^\s*import\s+['"]([^'"]+)['"]''');

  for (final file in dartFiles) {
    final normalizedPath = file.path.replaceAll('\\', '/');
    final lines = file.readAsLinesSync();

    // Determine feature name if in features/
    final featureMatch = RegExp(
      r'lib/features/([^/]+)/',
    ).firstMatch(normalizedPath);
    final currentFeature = featureMatch?.group(1);

    final isCubitOrBloc =
        normalizedPath.contains('/cubit/') || normalizedPath.contains('/bloc/');
    final isUi = normalizedPath.contains('/ui/');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNum = i + 1;
      final trimmed = line.trim();

      // Skip single line comments
      if (trimmed.startsWith('//')) continue;

      // Check Rule 4: No print() calls
      if (printRegex.hasMatch(line) &&
          !line.contains('avoid_print') &&
          !line.contains('token-check: allow')) {
        violations.add(
          '$normalizedPath:$lineNum: Found forbidden `print(` call. Use `AppLogger` instead.',
        );
      }

      // Check import boundaries
      final importMatch = importRegex.firstMatch(trimmed);
      if (importMatch != null) {
        final importUri = importMatch.group(1)!;

        // Check Rule 1: No cross-feature imports
        if (currentFeature != null) {
          final crossFeatureMatch = RegExp(
            r'features/([^/]+)/',
          ).firstMatch(importUri);
          if (crossFeatureMatch != null) {
            final importedFeature = crossFeatureMatch.group(1);
            if (importedFeature != currentFeature) {
              violations.add(
                '$normalizedPath:$lineNum: Feature "$currentFeature" cannot import feature "$importedFeature". Move shared code to `core/`.',
              );
            }
          }
        }

        // Check Rule 2: Cubit/Bloc cannot import data sources or *_impl.dart
        if (isCubitOrBloc) {
          if (importUri.contains('/data/datasources/')) {
            violations.add(
              '$normalizedPath:$lineNum: Cubit/Bloc cannot import from `data/datasources/`. Depend on the repository interface instead.',
            );
          }
          if (importUri.endsWith('_impl.dart') ||
              importUri.contains('_impl.dart')) {
            violations.add(
              '$normalizedPath:$lineNum: Cubit/Bloc cannot import concrete implementation `$importUri`. Depend on the repository interface instead.',
            );
          }
        }

        // Check Rule 3: UI cannot import data sources
        if (isUi) {
          if (importUri.contains('/data/datasources/')) {
            violations.add(
              '$normalizedPath:$lineNum: UI layer cannot import data sources `$importUri`. Depend on Cubits/Blocs.',
            );
          }
        }
      }
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln('❌ Architecture violations found (${violations.length}):');
    for (final v in violations) {
      stderr.writeln('  • $v');
    }
    exit(1);
  }

  stdout.writeln('✅ Architecture check passed: 0 violations found.');
  exit(0);
}
