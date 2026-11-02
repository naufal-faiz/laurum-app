import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';
import 'r10_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('incorrect credentials show safe error; correct email login opens queue', (
    tester,
  ) async {
    final scope = r10Scope();
    final host = await pumpAntrean(tester, container: scope, location: '/masuk');
    await fillAuthField(tester, 'Email', 'ratna@example.com');
    await fillAuthField(tester, 'Password', 'wrong');
    await tapAuthButton(tester, 'Masuk');
    expect(find.text('Email atau password tidak cocok.'), findsOneWidget);
    expect(host.router.routeInformationProvider.value.uri.path, '/masuk');
    await fillAuthField(tester, 'Password', 'Laundry123!');
    await tapAuthButton(tester, 'Masuk');
    expect(find.text('Antrean aktif'), findsOneWidget);
    expect(scope.read(authServiceProvider).usesPassword, isTrue);
  });
  testWidgets('reset notice identical; cooldown persists across leaving page and expires', (
    tester,
  ) async {
    final scope = r10Scope();
    final host = await pumpAntrean(tester, container: scope, location: '/lupa-password');
    await fillAuthField(tester, 'Email', 'ratna@example.com');
    await tapAuthButton(tester, 'Kirim tautan reset');
    expect(find.text('Jika email terdaftar, tautan dikirim'), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Kirim ulang (60 dtk)')).onPressed,
      isNull,
    );
    host.router.go('/masuk');
    await tester.pumpAndSettle();
    host.router.go('/lupa-password');
    await tester.pumpAndSettle();
    expect(find.textContaining('Kirim ulang ('), findsOneWidget);
    await fillAuthField(tester, 'Email', 'unknown@example.com');
    await tester.pump(const Duration(seconds: 61));
    await tester.pumpAndSettle();
    await tapAuthButton(tester, 'Kirim tautan reset');
    expect(find.text('Jika email terdaftar, tautan dikirim'), findsOneWidget);
    final auth = scope.read(authServiceProvider) as FakeAuthService;
    expect(auth.authActionLogs.where((a) => a == 'sendPasswordReset'), hasLength(2));
    expect(auth.authActionLogs.join(), isNot(contains('@')));
    await tester.pump(const Duration(seconds: 61));
    await tester.pumpAndSettle();
  });
}
