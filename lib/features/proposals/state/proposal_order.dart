import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

Future<Order> saveProposalOrder(
  Ref ref,
  Proposal proposal,
  ProposalDraft draft,
  String customerId,
  ServiceItem service,
) async {
  final repo = ref.read(orderRepositoryProvider);
  final profile = await ref.read(businessRepositoryProvider).getProfile();
  final now = ref.read(businessClockProvider)();
  final kilo = service.kind == ServiceKind.kiloan;
  final qtyMilli = kilo ? draft.weightMilli : 1000;
  final total = lineTotal(qtyMilli: qtyMilli, unitPrice: service.price);
  final order = Order(
    id: ref.read(idGeneratorProvider).derived(proposal.id, 'order'),
    ownerId: proposal.ownerId,
    createdAt: now,
    orderNo: await ref
        .read(orderNumberGeneratorProvider)
        .reserveOrderNo(
          (await repo.getOrders()).map((o) => o.orderNo),
        ),
    customerId: customerId,
    status: initialOrderStatus(OrderSource.whatsappAi, useOrderStatus: profile.useOrderStatus),
    source: OrderSource.whatsappAi,
    proposalId: proposal.id,
    discount: 0,
    enteredAt: now,
    estimatedAt: estimateReady(now, [service]),
    subtotal: total,
    total: total,
    note: [
      if (draft.address.trim().isNotEmpty) 'Alamat penjemputan: ${draft.address.trim()}',
      if (kilo && qtyMilli == 0) 'Berat belum diisi. Lengkapi lewat Edit order.',
    ].join('\n'),
  );
  await repo.saveOrder(
    order,
    useOrderStatus: profile.useOrderStatus,
    items: [
      OrderItem(
        id: ref.read(idGeneratorProvider).derived(order.id, 'item'),
        ownerId: order.ownerId,
        createdAt: now,
        orderId: order.id,
        serviceId: service.id,
        serviceName: service.name,
        unit: kilo ? 'kg' : 'pcs',
        qtyMilli: qtyMilli,
        unitPrice: service.price,
        lineTotal: total,
      ),
    ],
  );
  return order;
}
