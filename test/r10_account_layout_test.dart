import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/auth/widgets/account_danger_section.dart';
import 'package:laurum/features/auth/widgets/account_profile_section.dart';
import 'package:laurum/features/auth/widgets/account_security_section.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    for (final password in [true, false]) {
      testWidgets('account rows remain aligned at 320px, font$scale, password=$password', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 1200);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        final data = (
          name: 'Nama pemilik akun yang panjang',
          email: 'pemilik.usaha@example.com',
          phone: '081234567890',
          googleLinked: !password,
          usesPassword: password,
        );
        var calls = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AccountProfileSection(data: data, busy: false, onName: () {}, onPhone: () {}),
                      AccountSecuritySection(data: data, busy: false, onPassword: () => calls++),
                      AccountDangerSection(
                        busy: false,
                        offline: false,
                        onLogout: () {},
                        onDelete: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        final first = tester.getRect(find.byKey(const ValueKey('account-password-row')));
        final second = tester.getRect(find.byKey(const ValueKey('account-google-row')));
        expect(first.width, second.width);
        expect(first.height, closeTo(second.height, 0.01));
        expect(tester.getTopLeft(find.text('Nama')).dx, tester.getTopLeft(find.text('Email')).dx);
        expect(
          tester.getTopLeft(find.text('Nama')).dx,
          tester.getTopLeft(find.text('No. telp')).dx,
        );
        await tester.ensureVisible(find.text('Ganti password'));
        await tester.tap(find.text('Ganti password'));
        expect(calls, password ? 1 : 0);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
