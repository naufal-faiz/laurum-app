import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

Future<bool> openProposalWhatsApp(WidgetRef ref, String phone) =>
    ref.read(externalLauncherProvider).launchWhatsApp(phone: phone, message: '');

Future<void> approveReviewedProposal(
  BuildContext context,
  WidgetRef ref,
  ProposalReview review,
  ProposalDraft draft,
) async {
  final p = review.proposal;
  if (p.cancelRequested) {
    final order = await ref.read(orderRepositoryProvider).getOrderById(p.orderId!);
    if (!context.mounted) return;
    final confirmed = await ConfirmModal.show(
      context: context,
      title: 'Batalkan order ${order?.orderNo ?? ''}?',
      message: 'Permintaan AI tidak membatalkan order tanpa persetujuan Anda.',
      confirmLabel: 'Ya, batalkan order',
      destructive: true,
      icon: AppIcons.alert,
    );
    if (confirmed != true) return;
  } else if (p.uncertainAddress) {
    final confirmed = await ConfirmModal.show(
      context: context,
      title: 'Alamat belum dipastikan',
      message: 'Periksa alamat penjemputan dengan pelanggan. Lanjutkan membuat order?',
      confirmLabel: 'Setujui jadi order',
      icon: AppIcons.location,
    );
    if (confirmed != true) return;
  }
  if (!context.mounted) return;
  final orderId = await ref.read(proposalActionsProvider(p.id).notifier).approve(draft);
  if (orderId != null && context.mounted) context.go('/order/$orderId');
}

Future<void> rejectReviewedProposal(BuildContext context, WidgetRef ref, String id) async {
  final confirmed = await ConfirmModal.show(
    context: context,
    title: 'Tolak usulan ini?',
    message: 'Usulan dipindahkan ke riwayat. Order dan pelanggan tidak diubah.',
    confirmLabel: 'Tolak',
    destructive: true,
    icon: AppIcons.close,
  );
  if (confirmed != true || !context.mounted) return;
  if (await ref.read(proposalActionsProvider(id).notifier).reject() && context.mounted) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/antrean');
    }
  }
}
