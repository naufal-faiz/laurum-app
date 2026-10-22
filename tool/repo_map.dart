import 'dart:io';

// Membuat docs/REPO_MAP.md: peta repo untuk agen, pengganti memindai folder.
// Jalankan: dart run tool/repo_map.dart (juga otomatis lewat check_all).

final _decl = RegExp(
  r'^(?:abstract |final |base |sealed |interface )*'
  r'(?:class|enum|mixin|extension type|extension|typedef)\s+(?!on\b)(\w+)',
  multiLine: true,
);
final _provider = RegExp(r'^final\s+(\w+Provider)\b', multiLine: true);

String _rel(File f) => f.path.replaceAll('\\', '/');

bool _wanted(File f) {
  final p = _rel(f);
  return p.endsWith('.dart') &&
      !RegExp(r'\.(g|freezed|gen)\.dart$').hasMatch(p) &&
      !p.contains('/.dart_tool/') &&
      !p.contains('/build/');
}

List<String> _names(String text) => [
  for (final m in _decl.allMatches(text)) m.group(1)!,
  for (final m in _provider.allMatches(text)) m.group(1)!,
];

Set<String> _registry() => {
  for (final line in File('docs/design/widget_registry.yaml').readAsLinesSync())
    if (RegExp(r'^\s*-\s*(\w+)').firstMatch(line) case final m?) m.group(1)!,
};

List<String> _dependencies() {
  final out = <String>[];
  var inDeps = false;
  for (final line in File('pubspec.yaml').readAsLinesSync()) {
    final t = line.trim();
    if (t.isEmpty || t.startsWith('#')) continue;
    if (RegExp(r'^(dev_)?dependencies:').hasMatch(line)) {
      inDeps = true;
    } else if (!line.startsWith(' ')) {
      inDeps = false;
    } else if (inDeps) {
      final m = RegExp(r'^  (\w+):').firstMatch(line);
      if (m != null) out.add(m.group(1)!);
    }
  }
  return out;
}

void main() {
  final files = [
    for (final dir in ['lib', 'widgetbook', 'test', 'tool'])
      if (Directory(dir).existsSync())
        ...Directory(dir).listSync(recursive: true).whereType<File>().where(_wanted),
  ]..sort((a, b) => _rel(a).compareTo(_rel(b)));

  final declared = <String>{};
  final body = StringBuffer();
  String? currentDir;
  for (final f in files) {
    final path = _rel(f);
    final text = f.readAsStringSync();
    final names = _names(text);
    if (path.startsWith('lib/shared/widgets/')) declared.addAll(names);
    final dir = path.substring(0, path.lastIndexOf('/'));
    if (dir != currentDir) {
      body
        ..writeln()
        ..writeln('### $dir/');
      currentDir = dir;
    }
    final count = f.readAsLinesSync().length;
    body.writeln('- ${path.split('/').last} ($count): ${names.join(', ')}');
  }

  final registry = _registry();
  final done = registry.intersection(declared);
  final missing = registry.difference(declared).toList()..sort();
  final out = StringBuffer()
    ..writeln('# REPO MAP')
    ..writeln()
    ..writeln('Dibuat otomatis oleh `dart run tool/repo_map.dart`. Jangan diedit manual.')
    ..writeln('Baca berkas ini sebagai pengganti memindai folder.')
    ..writeln()
    ..writeln('## Registry widget: ${done.length}/${registry.length} dibuat')
    ..writeln()
    ..writeln(
      missing.isEmpty ? 'Semua widget sudah dibuat.' : 'Belum dibuat: ${missing.join(', ')}',
    )
    ..writeln()
    ..writeln('## Dependensi')
    ..writeln()
    ..writeln(_dependencies().join(', '))
    ..writeln()
    ..writeln('## Berkas (jumlah baris): nama deklarasi')
    ..write(body);
  File('docs/REPO_MAP.md').writeAsStringSync('$out\n');
  stdout.writeln('REPO_MAP diperbarui: ${files.length} berkas');
}
