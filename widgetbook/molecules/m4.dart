import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/avatar_stack.dart';
import 'package:laurum/shared/widgets/molecules/create_action.dart';
import 'package:laurum/shared/widgets/molecules/metric_tile.dart';
import 'package:laurum/shared/widgets/molecules/mini_bar_chart.dart';
import 'package:laurum/shared/widgets/molecules/nav_item.dart';
import 'package:laurum/shared/widgets/molecules/rank_row.dart';
import 'package:laurum/shared/widgets/molecules/segmented_progress.dart';
import 'package:widgetbook/widgetbook.dart';

final metricTileUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Row(
      spacing: AppSpacing.small,
      children: [
        Expanded(
          child: MetricTile(label: 'Cuci', value: '4', color: AppColors.primary),
        ),
        Expanded(
          child: MetricTile(label: 'Setrika', value: '2', color: AppColors.illustration),
        ),
        Expanded(
          child: MetricTile(label: 'Siap', value: '2', color: AppColors.success),
        ),
      ],
    ),
  ),
);

final segmentedProgressUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: SegmentedProgress(
      segments: [
        (value: 4, color: AppColors.primary),
        (value: 2, color: AppColors.illustration),
        (value: 2, color: AppColors.success),
      ],
    ),
  ),
);

final miniBarChartUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: MiniBarChart(amounts: [1, 3, 2, 5, 4, 6, 7]),
  ),
);

final avatarStackUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: AvatarStack(initials: ['BR', 'PA', 'MS']),
  ),
);

final rankRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: RankRow(
      initials: 'BR',
      name: 'Bu Ratna',
      detail: '14 kali laundry',
      trailing: '14×',
    ),
  ),
);

final navItemUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSpacing.small,
      children: [
        NavItem(label: 'Beranda', icon: AppIcons.droplet, selected: true),
        NavItem(label: 'Antrean', icon: AppIcons.queue, selected: false),
      ],
    ),
  ),
);

final createActionUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Center(child: CreateAction(label: 'Transaksi')),
  ),
);

final m4Components = <WidgetbookComponent>[
  WidgetbookComponent(name: 'MetricTile', useCases: [metricTileUseCase]),
  WidgetbookComponent(name: 'SegmentedProgress', useCases: [segmentedProgressUseCase]),
  WidgetbookComponent(name: 'MiniBarChart', useCases: [miniBarChartUseCase]),
  WidgetbookComponent(name: 'AvatarStack', useCases: [avatarStackUseCase]),
  WidgetbookComponent(name: 'RankRow', useCases: [rankRowUseCase]),
  WidgetbookComponent(name: 'NavItem', useCases: [navItemUseCase]),
  WidgetbookComponent(name: 'CreateAction', useCases: [createActionUseCase]),
];
