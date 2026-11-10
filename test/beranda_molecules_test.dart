import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/molecules/avatar_stack.dart';
import 'package:laurum/shared/widgets/molecules/create_action.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';
import 'package:laurum/shared/widgets/molecules/metric_tile.dart';
import 'package:laurum/shared/widgets/molecules/mini_bar_chart.dart';
import 'package:laurum/shared/widgets/molecules/nav_item.dart';
import 'package:laurum/shared/widgets/molecules/rank_row.dart';
import 'package:laurum/shared/widgets/molecules/segmented_progress.dart';

Widget _host(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('MetricTile shows the coloured figure and label', (tester) async {
    await tester.pumpWidget(
      _host(const MetricTile(label: 'Proses', value: '2', color: AppColors.success)),
    );
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Proses'), findsOneWidget);
  });

  testWidgets('SegmentedProgress skips empty stages', (tester) async {
    await tester.pumpWidget(
      _host(
        const SegmentedProgress(
          segments: [
            (value: 0, color: AppColors.primary),
            (value: 2, color: AppColors.success),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('MiniBarChart ignores future days', (tester) async {
    await tester.pumpWidget(
      _host(const MiniBarChart(amounts: [1, null, 3, 4])),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('AvatarStack shows up to three initials', (tester) async {
    await tester.pumpWidget(_host(const AvatarStack(initials: ['BR', 'PA', 'MS', 'XX'])));
    expect(find.text('BR'), findsOneWidget);
    expect(find.text('MS'), findsOneWidget);
    expect(find.text('XX'), findsNothing);
  });

  testWidgets('RankRow opens its customer', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        RankRow(
          initials: 'BR',
          name: 'Bu Ratna',
          detail: '14 kali laundry',
          trailing: '14×',
          onTap: () => taps++,
        ),
      ),
    );
    await tester.tap(find.text('Bu Ratna'));
    expect(taps, 1);
  });

  testWidgets('NavItem uses the active glyph and fires once', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        NavItem(
          label: 'Antrean',
          icon: AppIcons.queue,
          activeIcon: AppIcons.queueActive,
          selected: true,
          onTap: () => taps++,
        ),
      ),
    );
    expect(
      tester.widget<AppIcon>(find.byType(AppIcon)).icon,
      AppIcons.queueActive,
    );
    await tester.tap(find.text('Antrean'));
    expect(taps, 1);
  });

  testWidgets('CreateAction exposes one ink well and the new label', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_host(CreateAction(label: 'Transaksi', onPressed: () => taps++)));
    expect(find.byType(InkWell), findsOneWidget);
    expect(find.text('Transaksi'), findsOneWidget);
    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });

  testWidgets('IconTile can draw the notification dot', (tester) async {
    await tester.pumpWidget(
      _host(
        const IconTile(icon: AppIcons.bell, size: 38, iconSize: 18, dot: true),
      ),
    );
    expect(tester.widget<IconTile>(find.byType(IconTile)).dot, isTrue);
  });
}
