import 'dart:io';

void main(List<String> args) {
  if (args.contains('--list-rules')) {
    _printRules();
    exit(0);
  }

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

  // Documented central route provider allowlist for assembly root
  const allowedCoreFeatureImporters = {'lib/core/routes/route_providers.dart'};

  for (final file in dartFiles) {
    final normalizedPath = file.path.replaceAll('\\', '/');
    final lines = file.readAsLinesSync();

    final featureMatch = RegExp(
      r'lib/features/([^/]+)/',
    ).firstMatch(normalizedPath);
    final currentFeature = featureMatch?.group(1);

    final isCubitOrBloc =
        normalizedPath.contains('/cubit/') || normalizedPath.contains('/bloc/');
    final isUi =
        normalizedPath.contains('/ui/') ||
        normalizedPath.contains('/widgets/screens/');
    final isCore = normalizedPath.startsWith('lib/core/');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNum = i + 1;
      final trimmed = line.trim();

      // Check Rule 8: No raw print() calls
      if (printRegex.hasMatch(line) && !trimmed.startsWith('//')) {
        if (!_isIgnored(lines, i, 'rule-8') && !_isIgnored(lines, i, 'print')) {
          violations.add(
            '$normalizedPath:$lineNum: [Rule 8: Design tokens & Clean code] Found forbidden print() call. Use AppLogger instead.',
          );
        }
      }

      // Check import boundaries
      final importMatch = importRegex.firstMatch(trimmed);
      if (importMatch != null) {
        final rawImportUri = importMatch.group(1)!;
        final resolvedUri = _resolveImport(normalizedPath, rawImportUri);

        // Check Rule 2: UI never sees transport packages directly
        if (isUi) {
          if (rawImportUri.startsWith('package:dio/') ||
              rawImportUri.startsWith('package:cloud_firestore/') ||
              rawImportUri.startsWith('package:supabase_flutter/') ||
              rawImportUri.startsWith('package:graphql_flutter/')) {
            if (!_isIgnored(lines, i, 'rule-2') &&
                !_isIgnored(lines, i, 'transport')) {
              violations.add(
                '$normalizedPath:$lineNum: [Rule 2: Result types] UI layer cannot import transport package "$rawImportUri". UI must remain backend-agnostic.',
              );
            }
          }
        }

        // Check Rule 5: lib/core/** cannot import lib/features/**
        if (isCore && !allowedCoreFeatureImporters.contains(normalizedPath)) {
          if (resolvedUri.startsWith('lib/features/')) {
            if (!_isIgnored(lines, i, 'rule-5') &&
                !_isIgnored(lines, i, 'core-import-feature')) {
              violations.add(
                '$normalizedPath:$lineNum: [Rule 5: Zero cross-feature imports] Core module "$normalizedPath" cannot import feature "$resolvedUri". Move shared code to lib/core/.',
              );
            }
          }
        }

        // Check Rule 5: No cross-feature imports
        if (currentFeature != null && resolvedUri.startsWith('lib/features/')) {
          final crossFeatureMatch = RegExp(
            r'lib/features/([^/]+)/',
          ).firstMatch(resolvedUri);
          if (crossFeatureMatch != null) {
            final importedFeature = crossFeatureMatch.group(1);
            if (importedFeature != currentFeature) {
              if (!_isIgnored(lines, i, 'rule-5') &&
                  !_isIgnored(lines, i, 'cross-feature')) {
                violations.add(
                  '$normalizedPath:$lineNum: [Rule 5: Zero cross-feature imports] Feature "$currentFeature" cannot import feature "$importedFeature". Move shared code to lib/core/.',
                );
              }
            }
          }
        }

        // Check Rule 1: Cubit/Bloc cannot import data sources or *_impl.dart
        if (isCubitOrBloc) {
          if (resolvedUri.contains('/data/datasources/')) {
            if (!_isIgnored(lines, i, 'rule-1') &&
                !_isIgnored(lines, i, 'datasource')) {
              violations.add(
                '$normalizedPath:$lineNum: [Rule 1: No domain layer] Cubit/Bloc cannot import data source "$resolvedUri". Depend on the repository interface instead.',
              );
            }
          }
          if (resolvedUri.contains('_impl.dart')) {
            if (!_isIgnored(lines, i, 'rule-1') &&
                !_isIgnored(lines, i, 'impl')) {
              violations.add(
                '$normalizedPath:$lineNum: [Rule 1: No domain layer] Cubit/Bloc cannot import concrete implementation "$resolvedUri". Depend on the repository interface instead.',
              );
            }
          }
        }

        // Check Rule 6: UI cannot import data sources, repositories, or direct injection
        if (isUi) {
          if (resolvedUri.contains('/data/datasources/')) {
            if (!_isIgnored(lines, i, 'rule-6') &&
                !_isIgnored(lines, i, 'rule-1')) {
              violations.add(
                '$normalizedPath:$lineNum: [Rule 6: Thin screens] UI layer cannot import data source "$resolvedUri". Screens must consume state from Cubit/Bloc.',
              );
            }
          }
          if (resolvedUri.contains('/data/repositories/') ||
              resolvedUri.contains('_repository_impl.dart')) {
            if (!_isIgnored(lines, i, 'rule-6') &&
                !_isIgnored(lines, i, 'repository')) {
              violations.add(
                '$normalizedPath:$lineNum: [Rule 6: Thin screens] UI layer cannot import repository "$resolvedUri". Screens must consume state from Cubit/Bloc.',
              );
            }
          }
          if (resolvedUri.contains('core/di/injection.dart')) {
            if (!_isIgnored(lines, i, 'rule-6') &&
                !_isIgnored(lines, i, 'injection')) {
              violations.add(
                '$normalizedPath:$lineNum: [Rule 6: Thin screens] UI layer cannot import "core/di/injection.dart". Screens must consume Cubits/Blocs via context, not the service locator.',
              );
            }
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

void _printRules() {
  stdout.writeln('Architecture Rules (Golden Rules Enforcement):');
  stdout.writeln(
    '  Rule 1: No domain layer - Cubits/Blocs depend on repository interfaces (data/repositories/i_*), never on data sources (data/datasources/) or concrete implementations (*_impl.dart).',
  );
  stdout.writeln(
    '  Rule 2: Result types - UI never sees transport types (Dio/Firebase/Supabase/GraphQL). Errors are converted to Failure.',
  );
  stdout.writeln(
    '  Rule 3: Freezed unions & ActionGuard - State classes are Freezed unions; Cubits/Blocs use ActionGuard for all async operations.',
  );
  stdout.writeln(
    '  Rule 4: Registration - Repository implementations use @LazySingleton; Cubits/Blocs use @injectable.',
  );
  stdout.writeln(
    '  Rule 5: Zero cross-feature imports - Features never import other features. lib/core/ cannot import lib/features/ (except central route_providers.dart).',
  );
  stdout.writeln(
    '  Rule 6: Thin screens - Screens only read state from Cubit/Bloc and render. UI files cannot import data/repositories/ or core/di/injection.dart.',
  );
  stdout.writeln(
    '  Rule 7: L10n & Central routing - User-facing strings must use l10n. Routes must be declared centrally in route_names.dart and app_router.dart.',
  );
  stdout.writeln(
    '  Rule 8: Design tokens & Clean code - No raw print() calls in production code. Use AppLogger instead.',
  );
  stdout.writeln('\nInline ignore format:');
  stdout.writeln('  // architecture-ignore: <rule-name> <reason>');
  stdout.writeln(
    '  Example: // architecture-ignore: rule-6 Custom screen requires direct injection',
  );
}

bool _isIgnored(List<String> lines, int lineIndex, String ruleKeyword) {
  final current = lines[lineIndex].toLowerCase();
  if (current.contains('// architecture-ignore:') &&
      current.contains(ruleKeyword.toLowerCase())) {
    return true;
  }

  if (lineIndex > 0) {
    final prev = lines[lineIndex - 1].toLowerCase();
    if (prev.contains('// architecture-ignore:') &&
        prev.contains(ruleKeyword.toLowerCase())) {
      return true;
    }
  }

  // Check top 5 lines of file for file-level ignore
  for (var i = 0; i < lines.length && i < 5; i++) {
    final top = lines[i].toLowerCase();
    if (top.contains('// architecture-ignore-file:') &&
        top.contains(ruleKeyword.toLowerCase())) {
      return true;
    }
    if (top.contains('// architecture-ignore: all')) {
      return true;
    }
  }

  return false;
}

String _resolveImport(String filePath, String importUri) {
  if (importUri.startsWith('package:flutter_starter/')) {
    return 'lib/${importUri.substring('package:flutter_starter/'.length)}';
  }

  if (importUri.startsWith('.')) {
    final fileSegments = filePath.split('/');
    fileSegments.removeLast(); // Remove filename to get directory

    final importSegments = importUri.split('/');
    for (final seg in importSegments) {
      if (seg == '.' || seg.isEmpty) {
        continue;
      } else if (seg == '..') {
        if (fileSegments.isNotEmpty) {
          fileSegments.removeLast();
        }
      } else {
        fileSegments.add(seg);
      }
    }
    return fileSegments.join('/');
  }

  return importUri;
}
