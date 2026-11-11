import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class ProposalServiceSection extends StatelessWidget {
  const ProposalServiceSection({
    required this.review,
    required this.draft,
    required this.enabled,
    required this.onService,
    super.key,
  });
  final ProposalReview review;
  final ProposalDraft draft;
  final bool enabled;
  final ValueChanged<String> onService;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const SectionHeader(
        title: 'Layanan yang diusulkan AI',
        titleColor: AppColors.primaryInk,
        subtitle: 'Periksa dan sesuaikan sebelum menyetujui',
      ),
      AppCard(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.xsmall,
          children: [
            const AppText('Layanan', variant: AppTextVariant.label, color: AppColors.ink3),
            for (final service in review.services.where((s) => s.id == draft.serviceId))
              AppText(service.name, variant: AppTextVariant.bodyStrong),
            if (review.services.any(
              (s) => s.id == draft.serviceId && s.kind == ServiceKind.kiloan,
            )) ...[
              const AppDivider(),
              const AppText('Berat', variant: AppTextVariant.label, color: AppColors.ink3),
              const Align(
                alignment: Alignment.centerLeft,
                child: AppBadge('Belum diketahui', variant: AppBadgeVariant.menungguJemput),
              ),
            ],
            const AppDivider(),
            for (final service in review.services.where((s) => s.id == draft.serviceId))
              Row(
                spacing: AppSpacing.small,
                children: [
                  const AppText('Tarif', variant: AppTextVariant.caption, color: AppColors.ink3),
                  Expanded(
                    child: AppText(
                      '${Formatters.rupiah(service.price)} / ${service.kind == ServiceKind.kiloan ? 'kg' : 'pcs'}',
                      variant: AppTextVariant.label,
                      color: AppColors.primaryInk,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      ChipBar(
        labels: review.services.map((s) => s.name).toList(),
        selectedIndex: review.services.any((s) => s.id == draft.serviceId)
            ? review.services.indexWhere((s) => s.id == draft.serviceId)
            : null,
        onSelected: enabled ? (i) => onService(review.services[i].id) : null,
      ),
      if (review.services.any((s) => s.id == draft.serviceId && s.kind == ServiceKind.kiloan))
        const AppText(
          'Berat belum diisi. Lengkapi setelah disetujui lewat Edit order.',
          variant: AppTextVariant.caption,
          color: AppColors.ink3,
        ),
    ],
  );
}
