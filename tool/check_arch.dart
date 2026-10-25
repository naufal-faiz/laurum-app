import 'dart:convert';
import 'dart:io';

const maxLines = 110;
const theme = 'lib/core/theme/';
const shared = 'lib/shared/widgets/';
const atoms = '${shared}atoms/';
const sheetOwner = '${shared}organisms/app_bottom_sheet.dart';

typedef Rule = ({RegExp re, String msg, List<String> only, List<String> banIn});
typedef Registry = ({
  Set<String> all,
  Set<String> stateful,
  Set<String> routes,
  Set<String> debt,
});

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
  rule(
    r'\bshowModalBottomSheet\s*[<(]',
    'sheet hanya lewat AppBottomSheet.show',
    only: [sheetOwner],
  ),
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
final importRe = RegExp(r"import\s+'([^']+)'");
const laurumPrefix = 'package:laurum/';
final sectionFileRe = RegExp(r'^lib/features/[^/]+/widgets/[a-z0-9_]+_section\.dart$');
final featureWidgetsRe = RegExp(r'^lib/features/[^/]+/widgets/');
final pageFileRe = RegExp(r'(_page|_sheet|_flow|_routes)\.dart$');
final pageNameRe = RegExp(r'\b([A-Z]\w*Page)\b');

bool hits(String p, String tok) =>
    tok == 'features/' ? p.startsWith(tok) : p.contains('widgets/$tok');

Registry loadRegistry() {
  final all = <String>{}, stateful = <String>{}, routes = <String>{};
  for (final raw in File('docs/design/widget_registry.yaml').readAsLinesSync()) {
    final m = RegExp(r'^\s*-\s*(\w+)(.*)$').firstMatch(raw);
    if (m == null) continue;
    all.add(m.group(1)!);
    if (m.group(2)!.contains('stateful')) stateful.add(m.group(1)!);
  }
  for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
    final path = f.path.replaceAll('\\', '/');
    if (!path.endsWith('/app_router.dart') && !path.endsWith('_routes.dart')) continue;
    routes.addAll(pageNameRe.allMatches(f.readAsStringSync()).map((m) => m.group(1)!));
  }
  final debtFile = File('tool/section_riverpod_debt.txt');
  final debt = debtFile.existsSync()
      ? debtFile
            .readAsLinesSync()
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty && !l.startsWith('#'))
            .toSet()
      : <String>{};
  return (all: all, stateful: stateful, routes: routes, debt: debt);
}

List<String> checkFile(String path, String text, Registry reg) {
  final out = <String>[];
  void add(int line, String msg) => out.add('$path:$line: $msg');
  final lines = const LineSplitter().convert(text);
  if (lines.length > maxLines) add(lines.length, 'file ${lines.length} baris (maks $maxLines)');
  final base = path.split('/').last;
  final inFeatures = path.startsWith('lib/features/');
  final isState = path.contains('/state/');
  final isSectionFile = sectionFileRe.hasMatch(path);
  final ownFeature = RegExp(r'^lib/features/([^/]+)/').firstMatch(path)?.group(1);
  if (path.contains('/pages/') && !pageFileRe.hasMatch(base) && base != 'app_router.dart') {
    add(1, 'pages/ hanya *_page/_sheet/_flow/_routes: pindah ke state/');
  }
  if (featureWidgetsRe.hasMatch(path) && !base.endsWith('_section.dart')) {
    add(1, 'widgets/ fitur hanya *_section.dart');
  }
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
    final raw = imp.group(1)!;
    final target = raw.startsWith(laurumPrefix) ? raw.substring(laurumPrefix.length) : raw;
    for (final e in layerBans.entries) {
      if (!path.startsWith('$shared${e.key}')) continue;
      for (final tok in e.value) {
        if (hits(target, tok)) add(i + 1, 'impor melanggar lapisan: $target');
      }
    }
    if (isSectionFile) {
      if (raw.startsWith('package:flutter_riverpod') && !reg.debt.contains(path)) {
        add(
          i + 1,
          'Section tanpa Riverpod: migrasikan atau catat utang di tool/section_riverpod_debt.txt',
        );
      }
      if (raw.startsWith('package:go_router') && !reg.debt.contains(path)) {
        add(
          i + 1,
          'Section tanpa go_router: migrasikan atau catat utang di tool/section_riverpod_debt.txt',
        );
      }
      if (target.startsWith('features/') &&
          target.contains('/widgets/') &&
          ownFeature != null &&
          !target.startsWith('features/$ownFeature/')) {
        add(i + 1, 'Section dilarang memakai widgets/ fitur lain: $target');
      }
    }
    if (isState &&
        (raw == 'package:flutter/material.dart' || raw.startsWith('package:go_router'))) {
      add(i + 1, 'state/ tanpa UI: $raw');
    }
  }
  for (final m in widgetClass.allMatches(text)) {
    final name = m.group(1)!, baseType = m.group(2)!;
    final line = '\n'.allMatches(text.substring(0, m.start)).length + 1;
    final isPage = inFeatures && name.endsWith('Page');
    final isSheet = inFeatures && name.endsWith('Sheet');
    final isSection = name.endsWith('Section');
    final isAppRoot = path == 'lib/app.dart';
    if (name.startsWith('_')) {
      add(line, 'widget privat dilarang: $name');
    } else if (isPage) {
      if (!reg.routes.contains(name)) add(line, 'Page bukan rute: pakai Section di widgets/');
    } else if (isSheet) {
      if (!path.endsWith('_sheet.dart')) add(line, 'Sheet hanya di features/*/pages/*_sheet.dart');
    } else if (isSection) {
      if (!isSectionFile) add(line, 'Section hanya di features/*/widgets/*_section.dart');
      final debtOk = reg.debt.contains(path) && baseType == 'ConsumerWidget';
      if (baseType != 'StatelessWidget' && !debtOk) {
        add(line, '$name harus StatelessWidget: data via konstruktor, aksi via callback');
      }
    } else if (!isAppRoot && !reg.all.contains(name)) {
      add(line, 'widget tidak ada di registry: $name');
    }
    if (baseType.contains('Stateful') && !reg.stateful.contains(name)) {
      add(line, 'stateful tidak diizinkan: $name');
    }
    if (isState) add(line, 'state/ tanpa kelas Widget: $name');
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
