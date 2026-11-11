import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class OrderTimelineSection extends StatelessWidget {
  const OrderTimelineSection({required this.data, super.key});
  final OrderDetailData data;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'Jejak aktivitas', titleColor: AppColors.primaryInk),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            for (final entry in data.activity)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xsmall),
                    child: AppIcon(
                      AppIcons.dot,
                      size: AppSpacing.small,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.cardGap),
                  Expanded(child: AppText(entry.label)),
                  const SizedBox(width: AppSpacing.cardGap),
                  AppText(
                    Formatters.jam(entry.at),
                    variant: AppTextVariant.caption,
                    color: AppColors.ink3,
                  ),
                ],
              ),
          ],
        ),
      ),
    ],
  );
}
