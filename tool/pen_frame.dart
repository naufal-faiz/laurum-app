import 'dart:convert';
import 'dart:io';

// dart run tool/pen_frame.dart          -> daftar nama frame
// dart run tool/pen_frame.dart "Nama"   -> semua teks di dalam frame
void texts(Object? n, List<String> out) {
  if (n is! Map<String, dynamic>) return;
  if (n['type'] == 'text') out.add('${n['content']}');
  for (final c in (n['children'] as List<dynamic>? ?? const [])) {
    texts(c, out);
  }
}

void main(List<String> args) {
  final doc =
      jsonDecode(File('docs/design/laurum-ready.pen').readAsStringSync()) as Map<String, dynamic>;
  final frames = (doc['children'] as List<dynamic>).cast<Map<String, dynamic>>();
  if (args.isEmpty) {
    frames.map((f) => '${f['name']}').forEach(stdout.writeln);
    return;
  }
  for (final f in frames.where((f) => f['name'] == args.first)) {
    final out = <String>[];
    texts(f, out);
    out.forEach(stdout.writeln);
  }
}
