import 'package:flutter/material.dart';
import 'package:laurum/core/domain/service_revenue.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppMoleculeTokens.gap,
        children: [
          SectionHeader(title: title, subtitle: 'Berdasarkan pendapatan'),
          for (final (index, service) in services.indexed)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppMoleculeTokens.labelGap,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == 0 ? AppColors.primary : AppColors.chipIdle,
                        shape: BoxShape.circle,
                      ),
                      child: AppText(
                        '${index + 1}',
                        variant: AppTextVariant.label,
                        color: index == 0 ? AppColors.onPrimary : AppColors.ink2,
                      ),
                    ),
                    const SizedBox(width: AppMoleculeTokens.gap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(service.serviceName, variant: AppTextVariant.bodyStrong),
                          AppText(
                            _quantity(service),
                            variant: AppTextVariant.caption,
                            color: AppColors.ink3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppMoleculeTokens.gap),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          Formatters.rupiah(service.revenue),
                          variant: AppTextVariant.bodyStrong,
                        ),
                        AppText(
                          '${total == 0 ? 0 : (service.revenue * 100 / total).round()}% pendapatan',
                          variant: AppTextVariant.label,
                          color: index == 0 ? AppColors.primary : AppColors.ink2,
                        ),
                      ],
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: AppRadius.chip,
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : service.revenue / total,
                    minHeight: 8,
                    color: AppColors.primary,
                    backgroundColor: AppColors.chipIdle,
                    semanticsLabel: service.serviceName,
                  ),
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
