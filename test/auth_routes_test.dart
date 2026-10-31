import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('signed-out deep link redirects; Google sign in opens queue', (tester) async {
    final scope = ProviderContainer(
      overrides: dummyOverrides(authService: FakeAuthService(isSignedIn: false)),
    );
    final host = await pumpAntrean(tester, container: scope, location: '/pelanggan/cust-001');
    expect(host.router.routeInformationProvider.value.uri.path, '/masuk');
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Lupa kata sandi?'), findsNothing);
    await tester.tap(find.text('Lanjutkan dengan Google'));
    await tester.pumpAndSettle();
    expect(find.text('Antrean aktif'), findsOneWidget);
    expect(scope.read(authSessionProvider).signedIn, isTrue);
  });
  testWidgets('new account must finish blank business info before queue', (tester) async {
    final scope = ProviderContainer(
      overrides: dummyOverrides(
        authService: FakeAuthService(isSignedIn: false, needsBusinessSetup: true),
      ),
    );
    final host = await pumpAntrean(tester, container: scope, location: '/masuk');
    await tester.tap(find.text('Lanjutkan dengan Google'));
    await tester.pumpAndSettle();
    expect(find.text('Info usaha'), findsOneWidget);
    final name = find.byWidgetPredicate((w) => w is AppTextField && w.label == 'Nama usaha');
    expect(tester.widget<AppTextField>(name).value, '');
    host.router.go('/antrean');
    await tester.pumpAndSettle();
    expect(find.text('Info usaha'), findsOneWidget);
    await tester.tap(find.widgetWithText(AppButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(scope.read(authSessionProvider).needsSetup, isTrue);
    await tester.enterText(
      find.descendant(of: name, matching: find.byType(TextField)),
      'Laundry Baru',
    );
    await tester.tap(find.widgetWithText(AppButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(scope.read(authSessionProvider).needsSetup, isFalse);
    expect(find.text('Antrean aktif'), findsOneWidget);
    expect(find.text('Laundry Baru'), findsOneWidget);
  });
}
