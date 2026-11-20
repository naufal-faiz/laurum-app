import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/features/beranda/widgets/beranda_header_section.dart';
import 'package:laurum/features/reports/pages/report_page.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('whole revenue card opens weekly report after a different period', (tester) async {
    final host = await pumpAntrean(tester, location: '/beranda');
    final weekly = await host.container.read(weeklyReportViewProvider.future);
    host.container.read(reportPeriodProvider.notifier).select(2);
    await tester.pumpAndSettle();
    final monthly = await host.container.read(reportViewProvider.future);
    expect(monthly.period, 2);
    expect(identical(await host.container.read(weeklyReportViewProvider.future), weekly), isTrue);
    expect(weekly.period, 1);
    final card = find.ancestor(
      of: find.text('Pendapatan minggu ini'),
      matching: find.byType(AppCard),
    );
    await tester.ensureVisible(card);
    await tester.tapAt(tester.getTopLeft(card) + const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(ReportPage), findsOneWidget);
    expect(host.container.read(reportPeriodProvider), 1);
    expect(find.text('Minggu ini'), findsOneWidget);
    expect(find.byType(BerandaHeaderSection), findsNothing);
    expect(find.text('LAURUM'), findsNothing);
    expect(find.byType(RootScaffold), findsNothing);
    expect(find.byType(BottomNavBar), findsNothing);
    host.router.pop();
    await tester.pumpAndSettle();
    expect(find.byType(BerandaHeaderSection), findsOneWidget);
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('report from settings and direct link has no bottom navigation', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya');
    final navigation = host.router.push<void>('/laporan');
    await tester.pumpAndSettle();
    expect(find.byType(BottomNavBar), findsNothing);
    host.router.pop();
    await tester.pumpAndSettle();
    await navigation;
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(host.router.routeInformationProvider.value.uri.path, '/lainnya');
    host.router.go('/laporan');
    await tester.pumpAndSettle();
    expect(find.byType(BottomNavBar), findsNothing);
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(host.router.routeInformationProvider.value.uri.path, '/lainnya');
    expect(tester.takeException(), isNull);
  });
  testWidgets('home and login logo variants use circular surfaces and clips', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              IconTile.logo(),
              IconTile(
                icon: AppIcons.droplet,
                size: 42,
                iconSize: 20,
                imageAsset: 'assets/laurum-logo.png',
              ),
            ],
          ),
        ),
      ),
    );
    for (final tile in find.byType(IconTile).evaluate()) {
      final finder = find.byWidget(tile.widget);
      final box = tester.widget<DecoratedBox>(
        find.descendant(of: finder, matching: find.byType(DecoratedBox)).first,
      );
      expect((box.decoration as BoxDecoration).shape, BoxShape.circle);
      expect(find.descendant(of: finder, matching: find.byType(ClipOval)), findsOneWidget);
    }
  });
}
