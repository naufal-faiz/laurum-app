import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/domain/repositories/proposal_repository.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';

class InMemoryProposalRepository extends Notifier<List<Proposal>> implements ProposalRepository {
  @override
  List<Proposal> build() => List.unmodifiable(proposalFixtures);

  @override
  Future<List<Proposal>> getProposals({ProposalStatus? status}) async {
    if (status == null) return state;
    return state.where((p) => p.status == status).toList();
  }

  @override
  Future<Proposal?> getProposalById(String id) async {
    final match = state.where((p) => p.id == id);
    return match.isEmpty ? null : match.first;
  }

  @override
  Future<void> saveProposal(Proposal proposal) async {
    final idx = state.indexWhere((p) => p.id == proposal.id);
    if (idx >= 0) {
      state = List.unmodifiable([
        for (var i = 0; i < state.length; i++)
          if (i == idx) proposal else state[i],
      ]);
    } else {
      state = List.unmodifiable([...state, proposal]);
    }
  }

  @override
  Future<void> updateProposalStatus(
    String id,
    ProposalStatus status, {
    String? orderId,
  }) async {
    state = List.unmodifiable([
      for (final p in state)
        if (p.id == id)
          Proposal(
            id: p.id,
            ownerId: p.ownerId,
            createdAt: p.createdAt,
            status: status,
            sourceText: p.sourceText,
            customerId: p.customerId,
            orderId: orderId ?? p.orderId,
          )
        else
          p,
    ]);
  }
}

final inMemoryProposalRepositoryProvider =
    NotifierProvider<InMemoryProposalRepository, List<Proposal>>(
      InMemoryProposalRepository.new,
    );
