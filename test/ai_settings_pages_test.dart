import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/proposals/state/ai_settings.dart';
import 'package:laurum/features/proposals/state/whatsapp_link.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('settings toggle, confirmed disconnect and reconnect update shell', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya/ai');
    final toggle = find.widgetWithText(ToggleRow, 'Baca pesan WhatsApp');
    await tester.scrollUntilVisible(toggle, 180, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.descendant(of: toggle, matching: find.byType(AppSwitch)));
    await tester.pumpAndSettle();
    expect(host.container.read(aiSettingsProvider).readMessages, isFalse);
    tester.state<ScrollableState>(find.byType(Scrollable).first).position.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Putuskan koneksi'));
    await tester.pumpAndSettle();
    expect(find.text('Putuskan koneksi WhatsApp?'), findsOneWidget);
    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();
    expect(host.container.read(whatsappConnectionProvider), isTrue);
    await tester.tap(find.text('Putuskan koneksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Putuskan koneksi').last);
    await tester.pumpAndSettle();
    expect(host.container.read(whatsappConnectionProvider), isFalse);
    await tester.tap(find.text('Hubungkan WhatsApp'));
    await tester.pumpAndSettle();
    expect(find.text('Menunggu pindai'), findsOneWidget);
    await tester.tap(find.text('Periksa koneksi'));
    await tester.pumpAndSettle();
    expect(host.container.read(whatsappLinkProvider), WhatsappLinkStatus.connected);
    await tester.tap(find.text('Kembali ke pengaturan'));
    await tester.pumpAndSettle();
    expect(host.container.read(whatsappConnectionProvider), isTrue);
  });
  testWidgets('settings 320px 2x text has no overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/lainnya/ai', textScale: 2);
    expect(tester.takeException(), isNull);
  });
}
