import 'dart:convert';
import 'dart:io';

// Membaca docs/design/laurum-ready.pen tanpa konektor.
//   dart run tool/pen_frame.dart                      -> daftar frame
//   dart run tool/pen_frame.dart "Frame"              -> semua teks di frame
//   dart run tool/pen_frame.dart "Frame" --children   -> nama anak langsung
//   dart run tool/pen_frame.dart "Frame" "Anak"       -> teks di anak tertentu

List<Map<String, dynamic>> _kids(Map<String, dynamic> node) =>
    ((node['children'] as List<dynamic>?) ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList();

void _texts(Map<String, dynamic> n, List<String> out) {
  if (n['type'] == 'text') out.add('${n['content']}');
  for (final c in _kids(n)) {
    _texts(c, out);
  }
}

void main(List<String> args) {
  final doc =
      jsonDecode(File('docs/design/laurum-ready.pen').readAsStringSync())
          as Map<String, dynamic>;
  final frames = _kids(doc);
  if (args.isEmpty) {
    frames.map((f) => '${f['name']}').forEach(stdout.writeln);
    return;
  }
  for (final f in frames.where((f) => f['name'] == args.first)) {
    if (args.length > 1 && args[1] == '--children') {
      _kids(f).map((c) => '${c['name']}').forEach(stdout.writeln);
      continue;
    }
    final scope = args.length > 1
        ? _kids(f).where((c) => c['name'] == args[1])
        : [f];
    for (final s in scope) {
      final out = <String>[];
      _texts(s, out);
      out.forEach(stdout.writeln);
    }
  }
}
