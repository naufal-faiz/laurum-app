import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';

abstract class ProposalRepository {
  Future<List<Proposal>> getProposals({ProposalStatus? status});
  Future<Proposal?> getProposalById(String id);
  Future<void> saveProposal(Proposal proposal);
  Future<void> updateProposalStatus(
    String id,
    ProposalStatus status, {
    String? orderId,
  });
}
