import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class ProposalMessageSection extends StatelessWidget {
  const ProposalMessageSection({required this.review, required this.onWhatsApp, super.key});
  final ProposalReview review;
  final VoidCallback? onWhatsApp;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(
        title: 'Pemeriksaan usulan WhatsApp',
        subtitle: 'Periksa data dari pesan pelanggan sebelum menyetujui order.',
      ),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.cardGap,
          children: [
            SectionHeader(
              title: review.customer?.name ?? review.proposal.customerName,
              subtitle: Formatters.telepon(review.customer?.phone ?? review.proposal.phone),
              actionLabel: 'Buka WhatsApp',
              onAction: onWhatsApp,
            ),
            if (review.customer == null && review.proposal.status == ProposalStatus.menunggu)
              const AppBadge('Belum terdaftar', variant: AppBadgeVariant.menungguJemput),
            AppText(review.proposal.sourceText),
            AppText(Formatters.jam(review.proposal.createdAt), variant: AppTextVariant.caption),
          ],
        ),
      ),
    ],
  );
}
