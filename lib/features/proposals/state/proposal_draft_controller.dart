import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/features/proposals/state/proposal_draft.dart';
import 'package:laurum/features/proposals/state/proposal_review_data.dart';

class ProposalDraftController extends AsyncNotifier<ProposalDraft?> {
  ProposalDraftController(this.id);
  final String id;
  int? _estimatedWeight;
  bool _weightEdited = false;
  List<ServiceItem> _services = const [];
  @override
  Future<ProposalDraft?> build() async {
    _weightEdited = false;
    ref.listen(proposalReviewProvider(id), (_, next) => _receive(next));
    final review = await ref.read(proposalReviewProvider(id).future);
    if (review == null) return null;
    _estimatedWeight = review.proposal.estimatedWeightGrams;
    _services = review.services;
    return ProposalDraft(
      name: review.customer?.name ?? review.proposal.customerName,
      phone: review.customer?.phone ?? review.proposal.phone,
      address: review.proposal.address,
      serviceId: review.proposal.serviceId,
      weight: _weightFor(review.proposal.serviceId),
    );
  }

  void _receive(AsyncValue<ProposalReview?> next) {
    final review = next.asData?.value;
    if (review == null) return;
    _estimatedWeight = review.proposal.estimatedWeightGrams;
    _services = review.services;
    final draft = state.value;
    if (draft != null && !_weightEdited) {
      final value = _weightFor(draft.serviceId);
      if (draft.weight != value) state = AsyncData(draft.copyWith(weight: value));
    }
  }

  void name(String value) => state = AsyncData(state.value?.copyWith(name: value));
  void phone(String value) => state = AsyncData(state.value?.copyWith(phone: value));
  void address(String value) => state = AsyncData(state.value?.copyWith(address: value));
  void service(String value) {
    _weightEdited = false;
    state = AsyncData(state.value?.copyWith(serviceId: value, weight: _weightFor(value)));
  }

  String _weightFor(String id) => _services.any((s) => s.id == id && s.kind == ServiceKind.kiloan)
      ? proposalWeightText(_estimatedWeight)
      : '';
  void weight(String value) {
    _weightEdited = true;
    state = AsyncData(state.value?.copyWith(weight: normalizeProposalWeight(value)));
  }

  void retry() {
    ref.invalidate(proposalReviewProvider(id));
    ref.invalidateSelf();
  }
}
