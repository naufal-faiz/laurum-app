import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'antrean_test_host.dart';
import 'ui_final_routes.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final path in uiFinalRoutes) {
    testWidgets('UI audit $path at 320px / text 1.3', (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final public = ['/masuk', '/daftar', '/cek-email', '/lupa-password'].contains(path);
      final auth = public ? FakeAuthService(isSignedIn: false) : null;
      if (path == '/cek-email') {
        await auth!.signUp('audit@example.com', 'Audit123!', 'Uji UI');
      }
      final scope = ProviderContainer(overrides: dummyOverrides(authService: auth));
      await pumpAntrean(tester, container: scope, location: path, textScale: 1.3);
      expect(find.text('Halaman tidak ditemukan'), findsNothing, reason: path);
      expect(tester.takeException(), isNull, reason: path);
      if (path == '/lainnya/layanan/baru') {
        final price = tester.widget<AppTextField>(
          find.byWidgetPredicate((widget) => widget is AppTextField && widget.label == 'Harga'),
        );
        expect(price.value, '');
        expect(price.hint, '0');
      }
    });
  }
  testWidgets('main tabs have labeled targets at least 44dp', (tester) async {
    final semantics = tester.ensureSemantics();
    final host = await pumpAntrean(tester, textScale: 1.3);
    try {
      for (final path in ['/antrean', '/pelanggan', '/laporan', '/lainnya']) {
        host.router.go(path);
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      }
    } finally {
      semantics.dispose();
    }
  });
}
