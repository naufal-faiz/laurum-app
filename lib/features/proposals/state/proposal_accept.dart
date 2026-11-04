import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/cancellation.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/state/proposal_order.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

Future<String> acceptProposal(Ref ref, Proposal p, ProposalDraft draft) async {
  final orders = ref.read(orderRepositoryProvider);
  if (p.cancelRequested) {
    final order = await orders.getOrderById(p.orderId!);
    if (order == null) throw StateError('Order tidak ditemukan');
    if (order.status != OrderStatus.dibatalkan) {
      final savings = ref.read(savingsRepositoryProvider);
      final result = cancelOrder(
        order,
        payments: await orders.getPaymentsByOrderId(order.id),
        savings: await savings.getAllEntries(),
        ids: ref.read(idGeneratorProvider),
        correctionPrefix: '${p.id}-cancel',
        at: ref.read(businessClockProvider)(),
      );
      await orders.saveOrder(result.order, payments: result.payments, events: [result.event]);
      for (final entry in result.savings) {
        await savings.addEntry(entry);
      }
    }
    return order.id;
  }
  final previous = (await orders.getOrders()).where((o) => o.proposalId == p.id).firstOrNull;
  if (previous != null) return previous.id;
  final service = await ref.read(serviceRepositoryProvider).getServiceById(draft.serviceId);
  if (service == null || !service.isActive || !draft.valid) {
    throw StateError('Periksa nama dan layanan');
  }
  final customers = ref.read(customerRepositoryProvider);
  Customer? customer = p.customerId == null ? null : await customers.getCustomerById(p.customerId!);
  final digits = draft.phone.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^62'), '0');
  customer ??= (await customers.getCustomers())
      .where(
        (c) =>
            digits.isNotEmpty &&
            c.phone.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^62'), '0') == digits,
      )
      .firstOrNull;
  final isNew = customer == null;
  if (isNew && !draft.phoneValid) throw StateError('Nomor WhatsApp tidak valid');
  customer ??= Customer(
    id: ref.read(idGeneratorProvider).derived(p.id, 'customer'),
    ownerId: p.ownerId,
    createdAt: ref.read(businessClockProvider)(),
    name: draft.name.trim(),
    phone: draft.phone.trim(),
    address: draft.address.trim(),
  );
  if (isNew) await customers.saveCustomer(customer);
  return (await saveProposalOrder(ref, p, draft, customer.id, service)).id;
}
