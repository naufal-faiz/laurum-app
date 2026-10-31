import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/services/repository_providers.dart';

class ProposalReview {
  const ProposalReview(this.proposal, this.customer, this.services);
  final Proposal proposal;
  final Customer? customer;
  final List<ServiceItem> services;
  bool canApprove(ProposalDraft draft) =>
      proposal.cancelRequested ||
      draft.valid &&
          services.any((s) => s.id == draft.serviceId && s.isActive) &&
          (customer != null || draft.phoneValid);
}

String proposalPhoneKey(String value) =>
    value.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp('^62'), '0');

final proposalReviewProvider = FutureProvider.family<ProposalReview?, String>((ref, id) async {
  final proposals = ref.watch(proposalRepositoryProvider);
  final customers = ref.watch(customerRepositoryProvider);
  final services = ref.watch(serviceRepositoryProvider);
  final proposal = await proposals.getProposalById(id);
  if (proposal == null) return null;
  var customer = proposal.customerId == null
      ? null
      : await customers.getCustomerById(proposal.customerId!);
  if (customer == null && proposal.phone.isNotEmpty) {
    customer = (await customers.getCustomers())
        .where((c) => proposalPhoneKey(c.phone) == proposalPhoneKey(proposal.phone))
        .firstOrNull;
  }
  final all = await services.getServices();
  return ProposalReview(proposal, customer, [
    ...all.where((s) => s.id == proposal.serviceId),
    ...all.where((s) => s.id != proposal.serviceId),
  ]);
});

class ProposalDraft {
  const ProposalDraft({
    required this.name,
    required this.phone,
    required this.address,
    required this.serviceId,
  });
  final String name, phone, address, serviceId;
  bool get valid => name.trim().isNotEmpty && serviceId.isNotEmpty;
  bool get phoneValid =>
      RegExp(r'^08\d{8,11}$')
          .hasMatch(phone.replaceAll(RegExp(r'[\s()-]'), '').replaceFirst(RegExp(r'^\+?62'), '0'));
  ProposalDraft copyWith({String? name, String? phone, String? address, String? serviceId}) =>
      ProposalDraft(
        name: name ?? this.name,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        serviceId: serviceId ?? this.serviceId,
      );
}

class ProposalDraftController extends AsyncNotifier<ProposalDraft?> {
  ProposalDraftController(this.id);
  final String id;
  @override
  Future<ProposalDraft?> build() async {
    final review = await ref.read(proposalReviewProvider(id).future);
    if (review == null) return null;
    return ProposalDraft(
      name: review.customer?.name ?? review.proposal.customerName,
      phone: review.customer?.phone ?? review.proposal.phone,
      address: review.proposal.address,
      serviceId: review.proposal.serviceId,
    );
  }

  void name(String value) => state = AsyncData(state.value?.copyWith(name: value));
  void phone(String value) => state = AsyncData(state.value?.copyWith(phone: value));
  void address(String value) => state = AsyncData(state.value?.copyWith(address: value));
  void service(String value) => state = AsyncData(state.value?.copyWith(serviceId: value));
  void retry() {
    ref.invalidate(proposalReviewProvider(id));
    ref.invalidateSelf();
  }
}

final proposalDraftProvider =
    AsyncNotifierProvider.family<ProposalDraftController, ProposalDraft?, String>(
      ProposalDraftController.new,
    );
