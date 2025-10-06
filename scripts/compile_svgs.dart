// ignore_for_file: avoid_print

/// Compiles all SVG assets to .vec format for vector_graphics package.
///
/// This script processes all SVG files in the assets/ directory and generates
/// corresponding .vec files in assets/compiled/.
///
/// Run this script whenever SVG files are added or modified:
///   dart run scripts/compile_svgs.dart
///
/// Why this is needed:
/// The vector_graphics package requires pre-compiled .vec files when used in
/// a library package. The asset transformer approach only works in
/// applications, not across package boundaries.

library;

import 'dart:io';

const String _assetsPath = 'assets';
const String _compiledRelativePath = 'compiled';
const String _compiledPath = '$_assetsPath/$_compiledRelativePath';

void main() async {
  final assetsDir = Directory(_assetsPath);
  final compiledDir = Directory(_compiledPath);

  // Ensure compiled directory exists
  if (!compiledDir.existsSync()) {
    await compiledDir.create(recursive: true);
    print('Created $_compiledPath/ directory');
  }

  // Find all SVG files
  final svgFiles = <File>[];
  await for (final entity in assetsDir.list()) {
    if (entity is File && entity.path.endsWith('.svg')) {
      svgFiles.add(entity);
    }
  }

  if (svgFiles.isEmpty) {
    print('No SVG files found in $_assetsPath/');
    return;
  }

  print('Found ${svgFiles.length} SVG file(s) to compile...\n');

  // Compile all SVG files in parallel
  final compilationTasks = <Future<bool>>[];

  for (final svgFile in svgFiles) {
    final fileName = svgFile.uri.pathSegments.last;
    final inputPath = svgFile.path;
    final outputPath =
        '${compiledDir.path}${Platform.pathSeparator}$fileName.vec';

    compilationTasks.add(_compileSvg(fileName, inputPath, outputPath));
  }

  // Wait for all compilations to complete and count results
  final results = await Future.wait(compilationTasks);
  final successCount = results.where((success) => success).length;
  final errorCount = results.where((success) => !success).length;

  print('\n─────────────────────────────────────');
  print('Compilation complete!');
  print('Success: $successCount | Errors: $errorCount');
  print('─────────────────────────────────────');
}

/// Compiles a single SVG file to .vec format.
/// Prints the result immediately and returns true on success, false on error.
Future<bool> _compileSvg(
  String fileName,
  String inputPath,
  String outputPath,
) async {
  try {
    final result = await Process.run(
      'dart',
      [
        'run',
        'vector_graphics_compiler',
        '-i',
        inputPath,
        '-o',
        outputPath,
      ],
    );

    if (result.exitCode == 0) {
      print('✓ $fileName -> $_compiledRelativePath/$fileName.vec');
      return true;
    } else {
      final error = result.stderr.toString().trim();
      print('✗ $fileName - Error: $error');
      return false;
    }
  } catch (e) {
    print('✗ $fileName - Error: $e');
    return false;
  }
}
