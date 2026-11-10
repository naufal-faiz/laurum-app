import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionicons/ionicons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/auth/widgets/auth_password_field_section.dart';
import 'package:laurum/features/auth/widgets/auth_submit_section.dart';
import 'package:laurum/features/auth/widgets/sign_up_form_card_section.dart';
import 'package:laurum/features/auth/widgets/sign_up_hero_section.dart';

Widget _host(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);
void main() {
  testWidgets('Password visibility toggles and optional reset link', (
    tester,
  ) async {
    var toggles = 0, forgot = 0;
    await tester.pumpWidget(
      _host(
        AuthPasswordFieldSection(
          visible: false,
          busy: false,
          onPassword: (_) {},
          onToggle: () => toggles++,
          onForgot: () => forgot++,
        ),
      ),
    );
    expect(find.byIcon(Ionicons.eyeOutline), findsOneWidget);
    expect(find.byIcon(Ionicons.eyeOffOutline), findsNothing);
    await tester.tap(find.byIcon(Ionicons.eyeOutline));
    expect(toggles, 1);
    await tester.tap(find.text('Lupa password?'));
    expect(forgot, 1);
    await tester.pumpWidget(
      _host(
        AuthPasswordFieldSection(
          visible: true,
          busy: false,
          onPassword: (_) {},
          onToggle: () {},
        ),
      ),
    );
    expect(find.byIcon(Ionicons.eyeOffOutline), findsOneWidget);
    expect(find.text('Lupa password?'), findsNothing);
  });
  testWidgets('AuthSubmitSection: label without icon, disabled while busy', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        AuthSubmitSection(label: 'Daftar', busy: false, onSubmit: () => taps++),
      ),
    );
    expect(find.text('Daftar'), findsOneWidget);
    expect(find.byIcon(Ionicons.checkmark), findsNothing);
    await tester.tap(find.text('Daftar'));
    expect(taps, 1);
    await tester.pumpWidget(
      _host(AuthSubmitSection(label: 'Daftar', busy: true, onSubmit: () => taps++)),
    );
    await tester.tap(find.text('Daftar'));
    expect(taps, 1);
  });
  testWidgets('SignUpFormCardSection: fields, submit, Google and Masuk callbacks', (tester) async {
    final calls = <String>[];
    await tester.pumpWidget(
      _host(
        SignUpFormCardSection(
          name: '',
          email: '',
          visible: false,
          busy: false,
          restoring: false,
          onName: (v) => calls.add('name:$v'),
          onEmail: (v) => calls.add('email:$v'),
          onPassword: (v) => calls.add('password:$v'),
          onConfirmation: (v) => calls.add('confirmation:$v'),
          onToggle: () => calls.add('toggle'),
          onSubmit: () => calls.add('submit'),
          onGoogle: () => calls.add('google'),
          onSignIn: () => calls.add('signIn'),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField).at(0), 'Bu Ratna');
    await tester.enterText(find.byType(TextField).at(1), 'ratna@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'Laundry123!');
    await tester.enterText(find.byType(TextField).at(3), 'Laundry123!');
    await tester.tap(find.text('Daftar'));
    await tester.tap(find.text('Lanjutkan dengan Google'));
    await tester.tap(find.text('Masuk'));
    expect(calls, [
      'name:Bu Ratna',
      'email:ratna@example.com',
      'password:Laundry123!',
      'confirmation:Laundry123!',
      'submit',
      'google',
      'signIn',
    ]);
  });
  testWidgets('SignUpHeroSection: back callback', (tester) async {
    var back = 0;
    await tester.pumpWidget(_host(SignUpHeroSection(onBack: () => back++)));
    await tester.tap(find.byTooltip('Kembali'));
    expect(back, 1);
  });
}
