import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_root.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:widgetbook/widgetbook.dart';

final appBarRootUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        for (final state in SyncState.values)
          AppBarRoot(
            title: 'Business',
            accountLabel: 'Account',
            syncIndicator: SyncIndicator(state: state),
            onAccount: () {},
          ),
      ],
    ),
  ),
);
