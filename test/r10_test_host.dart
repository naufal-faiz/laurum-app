import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/auth/data/auth_fixtures.dart';
import 'package:laurum/features/auth/data/dummy_account_data.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

ProviderContainer r10Scope({bool signedIn = false, AuthService? auth}) => ProviderContainer(
  overrides: dummyOverrides(
    authService:
        auth ??
        FakeAuthService(
          isSignedIn: signedIn,
          userId: dummyOwnerId,
          email: dummyGoogleEmail,
          accounts: dummyAuthAccounts(),
        ),
  ),
);
Future<ProviderContainer> r10PasswordScope() async {
  final scope = r10Scope();
  await scope.read(authServiceProvider).signInWithPassword(dummyGoogleEmail, 'Laundry123!');
  return scope;
}

Finder authField(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(TextField),
);

Future<void> pumpAuthSection(WidgetTester tester, Widget child) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);
Future<void> fillAuthField(WidgetTester tester, String label, String value) async {
  final field = authField(label);
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

Future<void> tapAuthButton(WidgetTester tester, String label) async {
  final button = find.widgetWithText(AppButton, label).last;
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> tapAuthText(WidgetTester tester, String label) async {
  final text = find.text(label).last;
  await tester.ensureVisible(text);
  await tester.pumpAndSettle();
  await tester.tap(text);
  await tester.pumpAndSettle();
}
