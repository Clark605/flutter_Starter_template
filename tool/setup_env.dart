import 'dart:io';

/// Sets up local environment JSON files from committed example templates.
///
/// Usage:
///   dart run tool/setup_env.dart [--force]
void main(List<String> args) {
  final force = args.contains('--force') || args.contains('-f');
  final envDir = Directory('env');

  if (!envDir.existsSync()) {
    stderr.writeln(
      'Error: env/ directory not found in the root of the project.',
    );
    exitCode = 1;
    return;
  }

  final exampleFiles = envDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.example.json'))
      .toList();

  if (exampleFiles.isEmpty) {
    stdout.writeln('No .example.json files found in env/.');
    return;
  }

  var createdCount = 0;
  for (final exampleFile in exampleFiles) {
    final targetPath = exampleFile.path.replaceAll('.example.json', '.json');
    final targetFile = File(targetPath);

    if (targetFile.existsSync() && !force) {
      stdout.writeln(
        '  [SKIP] $targetPath already exists (use --force to overwrite)',
      );
    } else {
      exampleFile.copySync(targetPath);
      stdout.writeln(
        '  [CREATED] $targetPath created from ${exampleFile.path}',
      );
      createdCount++;
    }
  }

  stdout.writeln('\nEnvironment setup complete ($createdCount files created).');
}
