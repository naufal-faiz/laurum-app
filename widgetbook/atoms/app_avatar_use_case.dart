import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:widgetbook/widgetbook.dart';

final appAvatarUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        AppAvatar(initials: 'A', semanticLabel: 'Initials'),
        AppAvatar(semanticLabel: 'Fallback'),
      ],
    ),
  ),
);
