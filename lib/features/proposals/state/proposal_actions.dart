import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/state/proposal_accept.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';

class ProposalActions extends Notifier<AsyncValue<void>> {
  ProposalActions(this.id);
  final String id;
  @override
  AsyncValue<void> build() => const AsyncData(null);
  Future<String?> approve(ProposalDraft draft) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();
    try {
      final repo = ref.read(proposalRepositoryProvider);
      final p = await repo.getProposalById(id);
      if (p == null ||
          p.status == ProposalStatus.ditolak ||
          p.status == ProposalStatus.ditutupOtomatis) {
        throw StateError('Usulan tidak lagi menunggu');
      }
      final orderId = p.status == ProposalStatus.disetujui
          ? p.orderId!
          : await acceptProposal(ref, p, draft);
      if (p.status != ProposalStatus.disetujui) {
        await repo.saveProposal(
          p.withStatus(
            ProposalStatus.disetujui,
            orderId: orderId,
            customerName: draft.name,
            phone: draft.phone,
            address: draft.address,
            serviceId: draft.serviceId,
          ),
        );
      }
      state = const AsyncData(null);
      return orderId;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  Future<bool> reject() async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    try {
      final repo = ref.read(proposalRepositoryProvider);
      final p = await repo.getProposalById(id);
      final hasOrder = (await ref.read(orderRepositoryProvider).getOrders()).any(
        (o) => o.proposalId == id,
      );
      if (p == null || p.status != ProposalStatus.menunggu || hasOrder) {
        throw StateError('Usulan sudah diproses');
      }
      await repo.updateProposalStatus(id, ProposalStatus.ditolak);
      state = const AsyncData(null);
      return true;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return false;
    }
  }
}

final proposalActionsProvider = NotifierProvider.family<ProposalActions, AsyncValue<void>, String>(
  ProposalActions.new,
);
