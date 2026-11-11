import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/customer_contact_card.dart';

class ProposalMessageSection extends StatelessWidget {
  const ProposalMessageSection({
    required this.review,
    required this.onWhatsApp,
    this.demoAccuracy,
    super.key,
  });
  final ProposalReview review;
  final VoidCallback? onWhatsApp;
  final int? demoAccuracy;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      CustomerContactCard(
        name: review.customer?.name ?? review.proposal.customerName,
        phone: review.customer?.phone ?? review.proposal.phone,
        onContact: onWhatsApp,
        badge: review.customer == null && review.proposal.status == ProposalStatus.menunggu
            ? const AppBadge('Belum terdaftar', variant: AppBadgeVariant.menungguJemput)
            : null,
      ),
      const SectionHeader(title: 'Hasil bacaan AI', titleColor: AppColors.primaryInk),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.small,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: AppSpacing.small,
              children: [
                const Expanded(
                  child: Row(
                    spacing: AppSpacing.xxsmall,
                    children: [
                      AppIcon(
                        AppIcons.sparkles,
                        size: AppDimensions.iconSmall,
                        color: AppColors.primary,
                      ),
                      Expanded(
                        child: AppText(
                          'Dibaca dari pesan WhatsApp',
                          variant: AppTextVariant.caption,
                          color: AppColors.primaryInk,
                        ),
                      ),
                    ],
                  ),
                ),
                if (demoAccuracy != null)
                  Flexible(
                    child: AppBadge(
                      'Contoh akurasi $demoAccuracy%',
                      variant: AppBadgeVariant.diproses,
                    ),
                  ),
              ],
            ),
            AppCard(
              style: AppCardStyle.muted,
              padding: const EdgeInsets.all(AppSpacing.small),
              child: AppText(review.proposal.sourceText, variant: AppTextVariant.caption),
            ),
          ],
        ),
      ),
      const BannerMessage(message: 'Baca detail sebelum disetujui. AI bisa salah tafsir.'),
    ],
  );
}
