import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';

class FailingB1dProposal extends InMemoryProposalRepository {
  bool _failApproved = true;
  void allowApproval() => _failApproved = false;
  @override
  Future<void> saveProposal(Proposal proposal) async {
    await super.saveProposal(proposal);
    if (_failApproved && proposal.status == ProposalStatus.disetujui) {
      throw StateError('Injected after memory status write');
    }
  }
}
