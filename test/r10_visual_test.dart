import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/service_providers.dart';

import 'antrean_test_host.dart';
import 'r10_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final small in [false, true]) {
    for (final target in [
      'signin',
      'signup',
      'reset',
      'verify',
      'account',
      'name',
      'phone',
      'password',
      'signin_error',
    ]) {
      testWidgets('R10 $target width=${small ? 320 : 390} scale=${small ? 2 : 1}', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(small ? 320 : 390, 844);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        final account = ['account', 'name', 'phone', 'password'].contains(target);
        final scope = target == 'password' ? await r10PasswordScope() : r10Scope(signedIn: account);
        if (target == 'verify') {
          await scope
              .read(authServiceProvider)
              .signUp('new@example.com', 'NewPass123!', 'Nama Baru');
        }
        final path = switch (target) {
          'signup' => '/daftar',
          'reset' => '/lupa-password',
          'verify' => '/cek-email',
          'account' || 'name' || 'phone' || 'password' => '/lainnya/akun',
          _ => '/masuk',
        };
        await pumpAntrean(tester, container: scope, location: path, textScale: small ? 2 : 1);
        if (['name', 'phone', 'password'].contains(target)) {
          await tapAuthText(tester, switch (target) {
            'name' => 'Nama',
            'phone' => 'No. telp',
            _ => 'Ganti password',
          });
        }
        if (target == 'signin_error') {
          await fillAuthField(tester, 'Email', 'ratna@example.com');
          await fillAuthField(tester, 'Password', 'wrong');
          await tapAuthButton(tester, 'Masuk');
          expect(find.text('Email atau password tidak cocok.'), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
        if (small && target == 'account') {
          expect(tester.getSize(find.text('ratna@example.com')).height, lessThan(100));
          expect(tester.getSize(find.text('Ganti password')).height, lessThan(100));
        }
        if (!small || ['account', 'signup', 'password', 'signin_error'].contains(target)) {
          await expectLater(
            find.byKey(const ValueKey('antrean-golden')),
            matchesGoldenFile('goldens/r10_$target${small ? '_320_2x' : ''}.png'),
          );
        }
      });
    }
  }
}
