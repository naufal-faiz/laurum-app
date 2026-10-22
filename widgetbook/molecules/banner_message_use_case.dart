import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:widgetbook/widgetbook.dart';

final bannerMessageUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        for (final variant in BannerMessageVariant.values)
          BannerMessage(message: variant.name, variant: variant),
      ],
    ),
  ),
);
