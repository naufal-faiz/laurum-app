import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/state/service_edit_state.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';

class ServicePreviewSection extends StatelessWidget {
  const ServicePreviewSection({required this.state, super.key});
  final ServiceEditState state;

  @override
  Widget build(BuildContext context) => AppCard(
    style: AppCardStyle.primary,
    gradient: true,
    bubble: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.small,
      children: [
        const Row(
          children: [
            Expanded(
              child: AppText(
                'Pratinjau layanan',
                variant: AppTextVariant.caption,
                color: AppColors.heroTagline,
              ),
            ),
            SizedBox(width: AppSpacing.small),
            IconTile(
              icon: AppIcons.service,
              size: AppDimensions.backButton,
              iconSize: AppDimensions.iconAction,
              background: AppColors.illustration,
              foreground: AppColors.onPrimary,
            ),
          ],
        ),
        AppText(
          state.name.trim().isEmpty ? 'Layanan baru' : state.name,
          variant: AppTextVariant.section,
          color: AppColors.onPrimary,
        ),
        const AppText(
          'Atur nama, tarif, dan durasi pengerjaan',
          variant: AppTextVariant.caption,
          color: AppColors.heroTagline,
        ),
        Wrap(
          spacing: AppSpacing.xsmall,
          runSpacing: AppSpacing.xsmall,
          children: [
            for (final label in [
              state.kind == ServiceKind.kiloan ? 'Kiloan' : 'Satuan',
              '${Formatters.rupiah(state.price)}/${state.unitLabel}',
              '${state.durationDays} hari',
            ])
              AppBadge(label, variant: AppBadgeVariant.inverse),
          ],
        ),
      ],
    ),
  );
}
