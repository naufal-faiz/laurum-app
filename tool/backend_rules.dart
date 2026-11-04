const persistencePackages = [
  'drift',
  'supabase_flutter',
  'flutter_secure_storage',
  'connectivity_plus',
  'workmanager',
  'path_provider',
];

List<String> checkBackendPubspec(String text) =>
    RegExp(r'^\s*shared_preferences\s*:', multiLine: true).hasMatch(text)
    ? ['pubspec.yaml: shared_preferences dilarang (aturan 20)']
    : [];

List<String> checkBackendFile(String path, String text) {
  final problems = <String>[];
  final allowed =
      path.startsWith('lib/core/persistence/') ||
      path.startsWith('lib/core/sync/') ||
      RegExp(r'^lib/features/[^/]+/data/').hasMatch(path);
  final fixture = path.endsWith('_fixtures.dart');
  // Preserve line numbers while dropping standalone line comments.
  final source = text.replaceAllMapped(
    RegExp(r'^\s*//[^\n]*', multiLine: true),
    (m) => '\n' * '\n'.allMatches(m[0]!).length,
  );
  final imports = RegExp(r'''(?:import|export)\s+["']package:([^/"']+)''');
  for (final match in imports.allMatches(source)) {
    final package = match.group(1);
    final line = '\n'.allMatches(source.substring(0, match.start)).length + 1;
    if (package == 'shared_preferences') {
      problems.add('$path:$line: shared_preferences dilarang (aturan 20)');
    }
    if (!allowed && persistencePackages.contains(package)) {
      problems.add(
        '$path:$line: impor persistensi hanya di data/core persistence/sync (aturan 19)',
      );
    }
  }
  final rowId = RegExp(r'(?:\bid\s*:|\b(?:id|[a-zA-Z]+Id)\s*=)\s*([^;,\n]+)');
  final generatedText = RegExp(
    r'''["'][^"'\n]*\$|["'][^\n]*\+|\.length|microsecondsSinceEpoch|millisecondsSinceEpoch''',
  );
  if (!fixture) {
    for (final match in rowId.allMatches(source)) {
      if (!generatedText.hasMatch(match.group(1)!)) continue;
      final line = '\n'.allMatches(source.substring(0, match.start)).length + 1;
      problems.add('$path:$line: ID baris harus lewat IdGenerator (aturan 21)');
    }
  }
  return problems;
}
