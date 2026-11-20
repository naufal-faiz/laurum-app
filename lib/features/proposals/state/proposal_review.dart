import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/proposals/state/proposal_draft.dart';
import 'package:laurum/features/proposals/state/proposal_draft_controller.dart';

export 'package:laurum/features/proposals/state/proposal_draft.dart';
export 'package:laurum/features/proposals/state/proposal_draft_controller.dart';
export 'package:laurum/features/proposals/state/proposal_review_data.dart';

final proposalDraftProvider =
    AsyncNotifierProvider.family<ProposalDraftController, ProposalDraft?, String>(
      ProposalDraftController.new,
    );
