import 'dart:io';

// Satu perintah untuk semua pemeriksaan. Jalankan dari akar proyek:
//   dart run tool/check_all.dart
// Berhenti di kegagalan pertama. Berjalan sama di Windows, macOS, dan Linux.

typedef Step = ({String name, String cmd, List<String> args, String? needs});

const steps = <Step>[
  (
    name: 'format',
    cmd: 'dart',
    args: ['format', '--set-exit-if-changed', 'lib', 'test', 'tool'],
    needs: null,
  ),
  (name: 'analyze', cmd: 'flutter', args: ['analyze'], needs: null),
  (
    name: 'custom_lint',
    cmd: 'dart',
    args: ['run', 'custom_lint'],
    needs: 'custom_lint',
  ),
  (
    name: 'check_arch',
    cmd: 'dart',
    args: ['run', 'tool/check_arch.dart'],
    needs: null,
  ),
  (name: 'test', cmd: 'flutter', args: ['test'], needs: null),
];

bool hasDependency(String name) => RegExp(
  '^\\s+$name:',
  multiLine: true,
).hasMatch(File('pubspec.yaml').readAsStringSync());

Future<void> main() async {
  for (final step in steps) {
    final needs = step.needs;
    if (needs != null && !hasDependency(needs)) {
      stdout.writeln('== ${step.name}: dilewati ($needs belum terpasang)');
      continue;
    }
    stdout.writeln('== ${step.name}');
    final process = await Process.start(
      step.cmd,
      step.args,
      mode: ProcessStartMode.inheritStdio,
      runInShell: true,
    );
    final code = await process.exitCode;
    if (code != 0) {
      stderr.writeln('GAGAL di langkah "${step.name}" (kode $code)');
      exit(code);
    }
  }
  stdout.writeln('check_all: SEMUA HIJAU');
}
