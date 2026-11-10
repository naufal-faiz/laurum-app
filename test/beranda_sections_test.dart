import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/beranda/state/beranda_view.dart';
import 'package:laurum/features/beranda/widgets/beranda_frequent_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_header_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_queue_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_stats_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_welcome_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/avatar_stack.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';
import 'package:laurum/shared/widgets/molecules/metric_tile.dart';
import 'package:laurum/shared/widgets/molecules/mini_bar_chart.dart';
import 'package:laurum/shared/widgets/molecules/segmented_progress.dart';

Widget _host(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  testWidgets('BerandaHeaderSection shows brand and a dotted bell', (tester) async {
    await tester.pumpWidget(_host(const BerandaHeaderSection()));
    expect(find.text('LAURUM'), findsOneWidget);
    expect(find.text('Laundry Management'), findsOneWidget);
    expect(tester.widget<IconTile>(find.byType(IconTile).last).dot, isTrue);
    expect(
      tester.widgetList<IconTile>(find.byType(IconTile)).map((tile) => tile.icon),
      contains(AppIcons.bell),
    );
  });

  testWidgets('BerandaWelcomeSection passes the business name and action', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        BerandaWelcomeSection(
          businessName: 'Shanum Laundry',
          onManageQueue: () => taps++,
        ),
      ),
    );
    expect(find.text('Shanum Laundry'), findsOneWidget);
    final button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.iconAsset, AppSvgs.cursorBack);
    expect(button.iconQuarterTurns, 2);
    await tester.tap(find.text('Kelola antrean'));
    expect(taps, 1);
  });

  testWidgets('BerandaQueueSection shows totals and three service tiles', (tester) async {
    await tester.pumpWidget(
      _host(
        const BerandaQueueSection(
          total: 8,
          updatedLabel: 'Diperbarui 09.41',
          stages: [
            (label: 'Cuci Setrika', value: 4, tone: BerandaStageTone.primary),
            (label: 'Setrika', value: 2, tone: BerandaStageTone.illustration),
            (label: 'Cuci Lipat', value: 2, tone: BerandaStageTone.success),
          ],
        ),
      ),
    );
    expect(find.text('Antrean aktif'), findsOneWidget);
    expect(find.text('8 pesanan'), findsOneWidget);
    expect(find.text('Diperbarui 09.41'), findsOneWidget);
    expect(find.byType(MetricTile), findsNWidgets(3));
    expect(find.byType(SegmentedProgress), findsOneWidget);
  });

  testWidgets('welcome text and action remain separated at 320dp and double text', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 320,
          child: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: BerandaWelcomeSection(
              businessName: 'Laundry dengan nama panjang',
              onManageQueue: () => taps++,
            ),
          ),
        ),
      ),
    );
    final subtitle = tester.getRect(find.text('Siap untuk kembali bekerja'));
    final button = tester.getRect(find.byType(AppButton));
    expect(button.top - subtitle.bottom, greaterThanOrEqualTo(16));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Kelola antrean'));
    expect(taps, 1);
  });

  testWidgets('empty queue keeps its heading and shows no fake service tiles', (tester) async {
    await tester.pumpWidget(
      _host(
        const BerandaQueueSection(
          total: 0,
          updatedLabel: 'Belum ada antrean',
          stages: [],
        ),
      ),
    );
    expect(find.text('Antrean aktif'), findsOneWidget);
    expect(find.text('0 pesanan'), findsOneWidget);
    expect(find.text('Belum ada pesanan masuk.'), findsOneWidget);
    expect(find.byType(MetricTile), findsNothing);
    expect(find.byType(SegmentedProgress), findsNothing);
  });

  testWidgets('BerandaStatsSection shows customers, badge and chart', (tester) async {
    await tester.pumpWidget(
      _host(
        const BerandaStatsSection(
          savedCustomers: 128,
          newCustomers: 12,
          initials: ['B', 'P', 'M'],
          revenue: 'Rp 4.850.000',
          daily: [1, 2, 3, 4, 5, 6, 7],
        ),
      ),
    );
    expect(find.text('128'), findsOneWidget);
    expect(find.text('+12 baru'), findsOneWidget);
    expect(find.text('Rp 4.850.000'), findsOneWidget);
    expect(find.byType(AvatarStack), findsOneWidget);
    expect(find.byType(MiniBarChart), findsOneWidget);
  });

  testWidgets('BerandaFrequentSection opens a row and see-all', (tester) async {
    String? opened;
    var seeAll = 0;
    await tester.pumpWidget(
      _host(
        BerandaFrequentSection(
          rows: const [
            (
              id: 'c1',
              name: 'Bu Ratna',
              initials: 'BR',
              detail: '14 kali laundry',
              trailing: '14×',
            ),
          ],
          onOpen: (id) => opened = id,
          onSeeAll: () => seeAll++,
        ),
      ),
    );
    await tester.tap(find.text('Bu Ratna'));
    expect(opened, 'c1');
    await tester.tap(find.text('Lihat semua'));
    expect(seeAll, 1);
    expect(find.text('14 kali laundry'), findsOneWidget);
  });

  testWidgets('colour roles map to global tokens', (tester) async {
    await tester.pumpWidget(
      _host(
        const BerandaQueueSection(
          total: 3,
          updatedLabel: 'Diperbarui 10.00',
          stages: [
            (label: 'Jemput', value: 1, tone: BerandaStageTone.primary),
            (label: 'Proses', value: 1, tone: BerandaStageTone.illustration),
            (label: 'Siap', value: 1, tone: BerandaStageTone.success),
          ],
        ),
      ),
    );
    final colors = tester
        .widgetList<MetricTile>(find.byType(MetricTile))
        .map((tile) => tile.color)
        .toList();
    expect(colors, [AppColors.primary, AppColors.illustration, AppColors.success]);
  });
}
