import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/state/proposal_draft.dart';

class ProposalReview {
  const ProposalReview(this.proposal, this.customer, this.services);
  final Proposal proposal;
  final Customer? customer;
  final List<ServiceItem> services;
  bool canApprove(ProposalDraft draft) =>
      proposal.cancelRequested ||
      draft.valid &&
          services.any(
            (s) =>
                s.id == draft.serviceId &&
                s.isActive &&
                (s.kind != ServiceKind.kiloan || draft.weightError == null),
          ) &&
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
