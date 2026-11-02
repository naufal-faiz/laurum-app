import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/auth/state/password_reset_view.dart';
import 'package:laurum/features/auth/widgets/auth_identity_section.dart';
import 'package:laurum/features/auth/widgets/auth_passwords_section.dart';
import 'package:laurum/features/auth/widgets/auth_secret_field_section.dart';
import 'package:laurum/features/auth/widgets/password_reset_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'r10_test_host.dart';

void main() {
  testWidgets('identity fields delegate changes and show inline errors', (tester) async {
    String? email, name;
    await pumpAuthSection(
      tester,
      AuthIdentitySection(
        email: '',
        name: '',
        busy: false,
        errors: const {'email': 'Email tidak valid'},
        onEmail: (v) => email = v,
        onName: (v) => name = v,
      ),
    );
    await tester.enterText(authField('Email'), 'ratna@example.com');
    await tester.enterText(authField('Nama'), 'Bu Ratna');
    expect(email, 'ratna@example.com');
    expect(name, 'Bu Ratna');
    expect(find.text('Email tidak valid'), findsOneWidget);
    expect(
      tester.widgetList<AppTextField>(find.byType(AppTextField)).every((f) => f.selectAllOnFocus),
      isTrue,
    );
  });
  testWidgets('secret field obscures native input without copying it into widget value', (
    tester,
  ) async {
    String? entered;
    await pumpAuthSection(
      tester,
      AuthSecretFieldSection(
        label: 'Password',
        visible: false,
        busy: false,
        onChanged: (value) => entered = value,
      ),
    );
    await tester.enterText(authField('Password'), 'Private123!');
    expect(entered, 'Private123!');
    expect(tester.widget<TextField>(authField('Password')).obscureText, isTrue);
    expect(tester.widget<AppTextField>(find.byType(AppTextField)).value, '');
  });
  testWidgets('password group exposes current/new/confirm and visibility callback', (tester) async {
    var toggles = 0;
    await pumpAuthSection(
      tester,
      AuthPasswordsSection(
        visible: false,
        busy: false,
        onPassword: (_) {},
        onCurrent: (_) {},
        onConfirmation: (_) {},
        onToggle: () => toggles++,
      ),
    );
    expect(find.byType(AppTextField), findsNWidgets(3));
    await tapAuthButton(tester, 'Tampilkan password');
    expect(toggles, 1);
  });
  testWidgets('reset section shows generic response and email callback', (tester) async {
    String? entered;
    await pumpAuthSection(
      tester,
      PasswordResetSection(
        data: const PasswordResetView(sent: true),
        onEmail: (value) => entered = value,
      ),
    );
    expect(find.text('Jika email terdaftar, tautan dikirim'), findsOneWidget);
    await tester.enterText(authField('Email'), 'unknown@example.com');
    expect(entered, 'unknown@example.com');
    expect(tester.widget<AppTextField>(find.byType(AppTextField)).selectAllOnFocus, isTrue);
  });
}
