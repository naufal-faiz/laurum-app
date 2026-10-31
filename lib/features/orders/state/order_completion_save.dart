import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

Future<Order> loadCompletableOrder(Ref ref, String id) async {
  final profile = await ref.read(businessRepositoryProvider).getProfile();
  final order = await ref.read(orderRepositoryProvider).getOrderById(id);
  if (profile.useOrderStatus ||
      order == null ||
      order.status == OrderStatus.selesai ||
      order.status == OrderStatus.dibatalkan) {
    throw StateError('Order or mode changed');
  }
  return order;
}

Future<void> saveOrderCompletion(Ref ref, Order expected) async {
  final current = await loadCompletableOrder(ref, expected.id);
  if (current != expected) throw StateError('Order changed while printing');
  final now = ref.read(businessClockProvider)();
  await ref
      .read(orderRepositoryProvider)
      .updateOrderStatus(
        current.id,
        OrderStatus.selesai,
        useOrderStatus: false,
        event: OrderEvent(
          id: '${current.id}-status-selesai',
          ownerId: current.ownerId,
          createdAt: now,
          orderId: current.id,
          occurredAt: now,
          kind: 'status',
          fromStatus: current.status,
          toStatus: OrderStatus.selesai,
        ),
      );
  ref.invalidate(orderDetailProvider(current.id));
  ref.invalidate(antreanDataProvider);
  ref.invalidate(receiptViewProvider(current.id));
}
