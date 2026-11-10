import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';
import 'package:laurum/shared/widgets/molecules/rank_row.dart';

/// Frequent-customer card of frame `LAURUM · Beranda` (342x196).
class BerandaFrequentSection extends StatelessWidget {
  const BerandaFrequentSection({
    required this.rows,
    required this.onOpen,
    required this.onSeeAll,
    super.key,
  });

  final List<({String id, String name, String initials, String detail, String trailing})> rows;
  final void Function(String id) onOpen;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(AppSpacing.mediumLarge),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xsmall,
      children: [
        Row(
          children: [
            const Expanded(
              child: AppText(
                'Pelanggan paling sering',
                variant: AppTextVariant.bodyStrong,
                color: AppColors.primaryInk,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            InlineLink('Lihat semua', onTap: onSeeAll),
          ],
        ),
        if (rows.isEmpty)
          const AppText(
            'Belum ada pelanggan dengan riwayat order.',
            variant: AppTextVariant.caption,
            color: AppColors.ink3,
          )
        else
          for (final (index, row) in rows.indexed) ...[
            if (index > 0) const AppDivider(),
            RankRow(
              initials: row.initials,
              name: row.name,
              detail: row.detail,
              trailing: row.trailing,
              onTap: () => onOpen(row.id),
            ),
          ],
      ],
    ),
  );
}
