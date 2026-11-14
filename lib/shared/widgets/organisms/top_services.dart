import 'package:flutter/material.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class TopServices extends StatelessWidget {
  const TopServices({
    required this.services,
    super.key,
    this.totalRevenue,
    this.title = 'Layanan terlaris',
  });
  final List<ServiceRevenue> services;
  final int? totalRevenue;
  final String title;
  @override
  Widget build(BuildContext context) {
    final total = totalRevenue ?? services.fold<int>(0, (sum, item) => sum + item.revenue);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.mediumLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.small,
        children: [
          SectionHeader(title: title, subtitle: 'Berdasarkan pendapatan'),
          for (final (index, service) in services.indexed)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.xsmall,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.small,
                  children: [
                    AppBadge(
                      '${index + 1}',
                      variant: index == 0 ? AppBadgeVariant.diproses : AppBadgeVariant.selesai,
                    ),
                    const IconTile(
                      icon: AppIcons.service,
                      size: AppSpacing.xxlarge,
                      iconSize: AppDimensions.iconSmall,
                      background: AppColors.primaryTint,
                      radius: AppRadius.small,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(service.serviceName, variant: AppTextVariant.label),
                          AppText(
                            _quantity(service),
                            variant: AppTextVariant.caption,
                            color: AppColors.ink3,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppText(
                            Formatters.rupiah(service.revenue),
                            variant: AppTextVariant.label,
                            textAlign: TextAlign.end,
                          ),
                          AppText(
                            '${total == 0 ? 0 : (service.revenue * 100 / total).round()}% pendapatan',
                            variant: AppTextVariant.caption,
                            textAlign: TextAlign.end,
                            color: index == 0 ? AppColors.primary : AppColors.ink2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                LinearProgressIndicator(
                  value: total == 0 ? 0 : service.revenue / total,
                  minHeight: AppSpacing.xsmall,
                  borderRadius: AppRadius.small,
                  color: AppColors.primary,
                  backgroundColor: AppColors.chipIdle,
                  semanticsLabel: service.serviceName,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

String _quantity(ServiceRevenue service) => service.unit.isEmpty
    ? 'Pendapatan lainnya'
    : service.unit == 'kg'
    ? Formatters.berat(service.qtyMilli)
    : Formatters.jumlah(service.qtyMilli ~/ 1000);
