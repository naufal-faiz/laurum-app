import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/pages/report_page.dart';
import 'package:laurum/features/settings/widgets/settings_account_section.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('Lainnya golden and Laporan navigation', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/lainnya');
    expect(find.text('Pengaturan toko · Laurum v1.0.0'), findsOneWidget);
    expect(find.text('Nama, nomor HP, kata sandi'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/lainnya.png'),
    );
    await tester.tap(find.text('Laporan'));
    await tester.pumpAndSettle();
    expect(find.byType(ReportPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('account Section preserves disabled actions and empty email', (tester) async {
    var managed = 0, loggedOut = 0;
    for (final busy in [true, false]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SettingsAccountSection(
              busy: busy,
              onManage: () => managed++,
              onLogout: () => loggedOut++,
            ),
          ),
        ),
      );
      expect(find.text('Belum masuk'), findsOneWidget);
      await tester.tap(find.text('Kelola akun'));
      await tester.tap(find.text('Keluar'));
      expect(managed, busy ? 0 : 1);
      expect(loggedOut, busy ? 0 : 1);
    }
  });
  testWidgets('compact menu keeps row interaction and boxed icon', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MenuRow(
            label: 'Laporan',
            icon: AppIcons.reports,
            compact: true,
            onTap: () => taps++,
          ),
        ),
      ),
    );
    final glyph = tester.widgetList<AppIcon>(find.byType(AppIcon)).first;
    expect(glyph.boxed, isTrue);
    expect(tester.getSize(find.byType(MenuRow)).height, greaterThanOrEqualTo(44));
    await tester.tapAt(tester.getTopRight(find.byType(MenuRow)) + const Offset(-5, 10));
    expect(taps, 1);
  });
  testWidgets('AppCard padding and content both activate the same callback', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppCard(onTap: () => taps++, child: const Text('Pendapatan')),
        ),
      ),
    );
    await tester.tapAt(tester.getTopLeft(find.byType(AppCard)) + const Offset(5, 5));
    await tester.tap(find.text('Pendapatan'));
    expect(taps, 2);
  });
}
