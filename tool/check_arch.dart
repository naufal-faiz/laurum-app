import 'dart:convert';
import 'dart:io';

const maxLines = 110;
const theme = 'lib/core/theme/';
const shared = 'lib/shared/widgets/';
const atoms = '${shared}atoms/';

typedef Rule = ({RegExp re, String msg, List<String> only, List<String> banIn});
typedef Registry = ({Set<String> all, Set<String> stateful});

Rule rule(String p, String msg, {List<String> only = const [], List<String> banIn = const []}) =>
    (re: RegExp(p), msg: msg, only: only, banIn: banIn);

final rules = <Rule>[
  rule(r'\bsetState\s*\(', 'setState dilarang: pakai Riverpod'),
  rule(r'\bprint\s*\(', 'print dilarang'),
  rule(r'\bIcons\.', 'Material Icons dilarang: pakai AppIcon'),
  rule(r'\bIonicons\.', 'Ionicons hanya di core/icons', only: ['lib/core/icons/']),
  rule(r'\bIcon\(', 'Icon() hanya di AppIcon', only: ['${atoms}app_icon.dart']),
  rule(r'\bSvgPicture\b', 'SvgPicture hanya di AppSvg', only: ['${atoms}app_svg.dart']),
  rule(r'<svg|SvgPicture\.string', 'SVG inline dilarang: simpan di assets/icons'),
  rule(r'\bColor\(0x|\bColors\.', 'warna hanya di core/theme', only: [theme]),
  rule(r'\bTextStyle\(', 'TextStyle hanya di core/theme', only: [theme]),
  rule(
    r'\bTextEditingController\(',
    'controller hanya di atom field',
    only: ['${atoms}app_text_field.dart', '${atoms}app_search_field.dart'],
  ),
  rule(r'\bWidget\s+_\w+\(', 'method pembangun widget dilarang'),
  rule(r'package:flutter_riverpod', 'widget bersama tanpa Riverpod', banIn: [shared]),
];

const layerBans = {
  'atoms/': ['molecules/', 'organisms/', 'templates/', 'features/'],
  'molecules/': ['organisms/', 'templates/', 'features/'],
  'organisms/': ['templates/', 'features/'],
  'templates/': ['features/'],
};

final widgetClass = RegExp(
  r'class\s+(_?\w+)\s+extends\s+(StatelessWidget|StatefulWidget|ConsumerWidget|ConsumerStatefulWidget)',
);
final importRe = RegExp(r"import\s+'package:laurum/([^']+)'");

bool hits(String p, String tok) =>
    tok == 'features/' ? p.startsWith(tok) : p.contains('widgets/$tok');

Registry loadRegistry() {
  final all = <String>{}, stateful = <String>{};
  for (final raw in File('docs/design/widget_registry.yaml').readAsLinesSync()) {
    final m = RegExp(r'^\s*-\s*(\w+)(.*)$').firstMatch(raw);
    if (m == null) continue;
    all.add(m.group(1)!);
    if (m.group(2)!.contains('stateful')) stateful.add(m.group(1)!);
  }
  return (all: all, stateful: stateful);
}

List<String> checkFile(String path, String text, Registry reg) {
  final out = <String>[];
  void add(int line, String msg) => out.add('$path:$line: $msg');
  final lines = const LineSplitter().convert(text);
  if (lines.length > maxLines) add(lines.length, 'file ${lines.length} baris (maks $maxLines)');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trimLeft().startsWith('//')) continue;
    for (final r in rules) {
      if (!r.re.hasMatch(line)) continue;
      final blocked = r.only.isNotEmpty
          ? !r.only.any(path.startsWith)
          : r.banIn.isNotEmpty
          ? r.banIn.any(path.startsWith)
          : true;
      if (blocked) add(i + 1, r.msg);
    }
    final imp = importRe.firstMatch(line);
    if (imp == null) continue;
    for (final e in layerBans.entries) {
      if (!path.startsWith('$shared${e.key}')) continue;
      for (final tok in e.value) {
        if (hits(imp.group(1)!, tok)) add(i + 1, 'impor melanggar lapisan: ${imp.group(1)}');
      }
    }
  }
  for (final m in widgetClass.allMatches(text)) {
    final name = m.group(1)!, base = m.group(2)!;
    final line = '\n'.allMatches(text.substring(0, m.start)).length + 1;
    final isPage = path.contains('/pages/') && RegExp(r'(Page|Sheet)$').hasMatch(name);
    final isAppRoot = path == 'lib/app.dart';
    if (name.startsWith('_')) {
      add(line, 'widget privat dilarang: $name');
    } else if (!isPage && !isAppRoot && !reg.all.contains(name)) {
      add(line, 'widget tidak ada di registry: $name');
    }
    if (base.contains('Stateful') && !reg.stateful.contains(name)) {
      add(line, 'stateful tidak diizinkan: $name');
    }
  }
  return out;
}

void main() {
  final reg = loadRegistry();
  final problems = <String>[];
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !RegExp(r'\.(g|freezed|gen)\.dart$').hasMatch(f.path));
  for (final f in files) {
    final path = f.path.replaceAll('\\', '/');
    problems.addAll(checkFile(path, f.readAsStringSync(), reg));
  }
  if (problems.isEmpty) {
    stdout.writeln('check_arch: OK');
    return;
  }
  problems.forEach(stderr.writeln);
  exit(1);
}
