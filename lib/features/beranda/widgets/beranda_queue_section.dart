import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/beranda/state/beranda_view.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';
import 'package:laurum/shared/widgets/molecules/metric_tile.dart';
import 'package:laurum/shared/widgets/molecules/segmented_progress.dart';

/// Active queue summary of frame `LAURUM · Beranda` (342x128).
class BerandaQueueSection extends StatelessWidget {
  const BerandaQueueSection({
    required this.total,
    required this.updatedLabel,
    required this.stages,
    super.key,
  });

  final int total;
  final String updatedLabel;
  final List<({String label, int value, BerandaStageTone tone})> stages;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.mediumLarge,
      children: [
        Row(
          spacing: AppSpacing.smallMedium,
          children: [
            const IconTile(
              icon: AppIcons.time,
              size: 38,
              iconSize: 19,
              background: AppColors.primaryTint,
              radius: AppRadius.logo,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Antrean aktif',
                    variant: AppTextVariant.label,
                    color: AppColors.primaryInk,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    updatedLabel,
                    variant: AppTextVariant.caption,
                    color: AppColors.ink3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AppBadge('$total pesanan', variant: AppBadgeVariant.siap),
          ],
        ),
        if (stages.isEmpty)
          AppText(
            total == 0 ? 'Belum ada pesanan masuk.' : 'Rincian layanan belum tersedia.',
            color: AppColors.ink3,
          )
        else
          Row(
            spacing: AppSpacing.small,
            children: [
              for (final stage in stages)
                Expanded(
                  child: MetricTile(
                    label: stage.label,
                    value: '${stage.value}',
                    color: _toneColor(stage.tone),
                  ),
                ),
            ],
          ),
        if (stages.isNotEmpty)
          SegmentedProgress(
            segments: [
              for (final stage in stages) (value: stage.value, color: _toneColor(stage.tone)),
            ],
          ),
      ],
    ),
  );
}

Color _toneColor(BerandaStageTone tone) => switch (tone) {
  BerandaStageTone.primary => AppColors.primary,
  BerandaStageTone.illustration => AppColors.illustration,
  BerandaStageTone.success => AppColors.success,
};
