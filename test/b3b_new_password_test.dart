import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';
import 'r10_test_host.dart';

FakeAuthService recoveryAuth() => FakeAuthService(email: 'ratna@example.com', recovering: true);

ProviderContainer recoveryScope() => ProviderContainer(
  overrides: dummyOverrides(authService: recoveryAuth()),
);

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('recovery link forces the new password screen and finishes it', (tester) async {
    final scope = recoveryScope();
    final host = await pumpAntrean(tester, container: scope, location: '/beranda');
    expect(host.router.routeInformationProvider.value.uri.path, '/password-baru');
    expect(find.text('Buat password baru'), findsWidgets);

    await fillAuthField(tester, 'Password baru', 'pendek');
    await fillAuthField(tester, 'Konfirmasi password', 'pendek');
    await tapAuthButton(tester, 'Simpan password');
    expect(find.text('Password minimal 8 karakter.'), findsOneWidget);
    expect(host.router.routeInformationProvider.value.uri.path, '/password-baru');

    await fillAuthField(tester, 'Password baru', 'NewPass123!');
    await fillAuthField(tester, 'Konfirmasi password', 'NewPass123!');
    await tapAuthButton(tester, 'Simpan password');
    expect(find.text('Password berhasil diperbarui'), findsOneWidget);

    await tapAuthButton(tester, 'Lanjut');
    expect(host.router.routeInformationProvider.value.uri.path, '/beranda');
    expect(scope.read(authServiceProvider).recovering, isFalse);
  });

  testWidgets('new password fields and save stay above a 300dp keyboard', (tester) async {
    configureKeyboardTest(tester, size: const Size(320, 844));
    final scope = recoveryScope();
    await pumpAntrean(tester, container: scope, location: '/password-baru');
    final save = find.widgetWithText(AppButton, 'Simpan password');
    await expectKeyboardVisible(tester, field: authField('Password baru'), save: save);
    await expectKeyboardVisible(tester, field: authField('Konfirmasi password'), save: save);
  });
}
