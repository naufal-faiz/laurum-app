import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';

class ProposalServiceCardSection extends StatelessWidget {
  const ProposalServiceCardSection({
    required this.serviceName,
    required this.weight,
    required this.total,
    required this.kilo,
    required this.enabled,
    required this.onChangeService,
    required this.onChangeWeight,
    super.key,
  });
  final String serviceName;
  final String? weight, total;
  final bool kilo, enabled;
  final VoidCallback? onChangeService, onChangeWeight;
  static const _pad = EdgeInsets.symmetric(
    horizontal: AppSpacing.mediumLarge,
    vertical: AppSpacing.smallMedium,
  );
  static const _divider = Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
    child: AppDivider(),
  );

  @override
  Widget build(BuildContext context) {
    final rows = [
      (
        'LAYANAN',
        AppText(serviceName, variant: AppTextVariant.bodyStrong),
        'Ubah',
        onChangeService,
      ),
      if (kilo)
        (
          'BERAT',
          AppBadge(
            weight ?? 'Belum diketahui',
            variant: weight == null ? AppBadgeVariant.menungguJemput : AppBadgeVariant.siap,
          ),
          'Isi berat',
          onChangeWeight,
        ),
    ];
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (label, value, action, onTap) in rows) ...[
            Padding(
              padding: _pad,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(label, variant: AppTextVariant.caption, color: AppColors.ink3),
                        value,
                      ],
                    ),
                  ),
                  if (onTap != null && enabled) InlineLink(action, onTap: onTap),
                ],
              ),
            ),
            _divider,
          ],
          Padding(
            padding: _pad,
            child: Row(
              children: [
                const AppText('Total', variant: AppTextVariant.caption, color: AppColors.ink3),
                const Spacer(),
                AppText(
                  total ?? 'Belum dihitung',
                  variant: AppTextVariant.label,
                  color: total == null ? AppColors.ink3 : AppColors.primaryInk,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
