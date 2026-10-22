import 'dart:io';

// Jalankan dari akar proyek: dart run tool/check_all.dart.
// Plugin Riverpod berjalan di flutter analyze; tidak perlu custom_lint.
// Berhenti di kegagalan pertama, di Windows, macOS, maupun Linux.
typedef Step = ({String name, String cmd, List<String> args});

const steps = <Step>[
  (
    name: 'format',
    cmd: 'dart',
    args: ['format', '--set-exit-if-changed', 'lib', 'test', 'tool'],
  ),
  (name: 'analyze (termasuk Riverpod)', cmd: 'flutter', args: ['analyze']),
  (name: 'check_arch', cmd: 'dart', args: ['run', 'tool/check_arch.dart']),
  (name: 'test', cmd: 'flutter', args: ['test']),
];

Future<void> main() async {
  for (final step in steps) {
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
