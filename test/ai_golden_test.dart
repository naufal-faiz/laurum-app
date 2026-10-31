import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final (name, route, connected) in [
    ('ai_settings', '/lainnya/ai', true),
    ('ai_settings_disconnected', '/lainnya/ai', false),
    ('whatsapp_waiting', '/lainnya/ai/hubungkan', false),
    ('whatsapp_connected', '/lainnya/ai/hubungkan', true),
  ]) {
    testWidgets('$name golden', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
      scope.read(whatsappConnectionProvider.notifier).setConnected(connected: connected);
      await pumpAntrean(tester, container: scope, location: route);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('antrean-golden')),
        matchesGoldenFile('goldens/$name.png'),
      );
      if (name == 'whatsapp_waiting') {
        await tester.pump(const Duration(minutes: 1));
        await tester.pumpAndSettle();
        expect(find.text('Kode kedaluwarsa'), findsOneWidget);
      }
    });
  }
  testWidgets('WhatsApp QR 320px 2x text remains usable', (tester) async {
    tester.view.physicalSize = const Size(320, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    scope.read(whatsappConnectionProvider.notifier).setConnected(connected: false);
    await pumpAntrean(tester, container: scope, location: '/lainnya/ai/hubungkan', textScale: 2);
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Periksa koneksi'));
    await tester.tap(find.text('Periksa koneksi'));
    await tester.pumpAndSettle();
    expect(scope.read(whatsappConnectionProvider), isTrue);
  });
}
