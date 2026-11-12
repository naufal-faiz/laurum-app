import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/widgets/new_password_section.dart';

import 'r10_test_host.dart';

void main() {
  testWidgets('new password section delegates fields and shows success or error', (
    tester,
  ) async {
    final calls = <String>[];
    await pumpAuthSection(
      tester,
      NewPasswordSection(
        data: const AuthFormView(),
        onPassword: (value) => calls.add('password:$value'),
        onConfirmation: (value) => calls.add('confirmation:$value'),
        onToggle: () => calls.add('toggle'),
      ),
    );
    expect(find.text('Masukkan password baru minimal 8 karakter.'), findsOneWidget);
    await tester.enterText(authField('Password baru'), 'NewPass123!');
    await tester.enterText(authField('Konfirmasi password'), 'NewPass123!');
    await tester.tap(find.text('Tampilkan password'));
    expect(calls, ['password:NewPass123!', 'confirmation:NewPass123!', 'toggle']);

    await pumpAuthSection(
      tester,
      NewPasswordSection(
        data: const AuthFormView(done: true),
        onPassword: (_) {},
        onConfirmation: (_) {},
        onToggle: () {},
      ),
    );
    expect(find.text('Password berhasil diperbarui'), findsOneWidget);
    expect(find.text('Simpan password'), findsNothing);

    await pumpAuthSection(
      tester,
      NewPasswordSection(
        data: const AuthFormView(error: 'Password baru tidak dapat disimpan.'),
        onPassword: (_) {},
        onConfirmation: (_) {},
        onToggle: () {},
      ),
    );
    expect(find.text('Password baru tidak dapat disimpan.'), findsOneWidget);
  });
}
