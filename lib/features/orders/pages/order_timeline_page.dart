import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class OrderTimelinePage extends StatelessWidget {
  const OrderTimelinePage({required this.data, super.key});
  final OrderDetailData data;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'Jejak aktivitas'),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            for (final entry in data.activity)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
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
