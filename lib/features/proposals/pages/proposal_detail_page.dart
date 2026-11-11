import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/pages/proposal_review_flow.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_demo_accuracy.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/proposals/widgets/proposal_fields_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_footer_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_message_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_privacy_section.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class ProposalDetailPage extends ConsumerWidget {
  const ProposalDetailPage({required this.id, super.key});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(proposalReviewProvider(id));
    final review = snapshot.value;
    final draft = ref.watch(proposalDraftProvider(id)).value;
    final action = ref.watch(proposalActionsProvider(id));
    final actions = ref.read(proposalDraftProvider(id).notifier);
    final pending = review?.proposal.status == ProposalStatus.menunggu;
    final enabled = pending && !action.isLoading;
    return FormScaffold(
      title: 'Periksa Usulan AI',
      subtitle: review == null
          ? null
          : 'Dari pesan WhatsApp · ${Formatters.jam(review.proposal.createdAt)}',
      appBarVariant: AppBarSubVariant.detail,
      trailing: pending ? const AppBadge('Perlu dicek', variant: AppBadgeVariant.diproses) : null,
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/antrean'),
      footer: review == null || draft == null
          ? const SizedBox.shrink()
          : ProposalFooterSection(
              review: review,
              draft: draft,
              enabled: enabled,
              onReject: () => rejectReviewedProposal(context, ref, id),
              onApprove: () => approveReviewedProposal(context, ref, review, draft),
              onOpen: () => context.push('/order/${review.proposal.orderId}'),
            ),
      body: snapshot.hasError
          ? AppButton('Coba lagi', onPressed: actions.retry)
          : snapshot.isLoading || draft == null && review != null
          ? const AppText('Memuat usulan...')
          : review == null
          ? const AppText('Usulan tidak ditemukan')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.cardGap,
              children: [
                if (action.hasError)
                  const BannerMessage(
                    message: 'Usulan gagal diproses. Coba lagi.',
                    variant: BannerMessageVariant.error,
                  ),
                if (!pending) AppText(proposalStatusLabel(review.proposal.status)),
                ProposalMessageSection(
                  review: review,
                  demoAccuracy: ref.watch(proposalDemoAccuracyProvider)[id],
                  onWhatsApp: draft?.phoneValid != true
                      ? null
                      : () => openProposalWhatsApp(ref, draft!.phone),
                ),
                ProposalFieldsSection(
                  review: review,
                  draft: draft!,
                  enabled: enabled,
                  onName: actions.name,
                  onPhone: actions.phone,
                  onAddress: actions.address,
                  onService: actions.service,
                ),
                const ProposalPrivacySection(),
              ],
            ),
    );
  }
}
