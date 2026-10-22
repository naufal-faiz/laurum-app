import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:widgetbook/widgetbook.dart';

final appIconUseCase = WidgetbookUseCase(
  name: 'Semua ikon dan ukuran',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Wrap(
      spacing: AppSpacing.cardGap,
      runSpacing: AppSpacing.cardGap,
      children: [
        for (final icon in AppIcons.values)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(icon, semanticLabel: icon.name),
              AppIcon(icon, size: AppDimensions.iconAction),
              AppIcon(icon, size: AppDimensions.iconSmall, color: AppColors.primary),
              AppText(icon.name, variant: AppTextVariant.caption),
            ],
          ),
      ],
    ),
  ),
);
