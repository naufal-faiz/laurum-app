import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/order_number_generator.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/domain/service_item.dart';
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
  final total = kilo ? 0 : service.price;
  final order = Order(
    id: 'ord-ai-${proposal.id}',
    ownerId: proposal.ownerId,
    createdAt: now,
    orderNo: const OrderNumberGenerator().nextOrderNo(
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
      if (kilo) 'Berat belum diisi. Lengkapi lewat Edit order.',
    ].join('\n'),
  );
  await repo.saveOrder(
    order,
    useOrderStatus: profile.useOrderStatus,
    items: [
      OrderItem(
        id: '${order.id}-item',
        ownerId: order.ownerId,
        createdAt: now,
        orderId: order.id,
        serviceId: service.id,
        serviceName: service.name,
        unit: kilo ? 'kg' : 'pcs',
        qtyMilli: kilo ? 0 : 1000,
        unitPrice: service.price,
        lineTotal: total,
      ),
    ],
  );
  return order;
}
