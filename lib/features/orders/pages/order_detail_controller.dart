import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/cancellation.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/pages/antrean_data.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';
import 'package:laurum/features/transactions/pages/receipt_view.dart';

typedef OrderActionState = ({Set<String> pending, String? error});
final orderActionsProvider = NotifierProvider<OrderActions, OrderActionState>(
  OrderActions.new,
);

class OrderActions extends Notifier<OrderActionState> {
  @override
  OrderActionState build() => (pending: const {}, error: null);

  Future<bool> advance(Order order) => _run(order.id, () async {
    final repository = ref.read(orderRepositoryProvider);
    final current = await repository.getOrderById(order.id);
    if (current == null || current.status != order.status) {
      throw StateError('Status order berubah');
    }
    final next = nextStatus(current.status);
    final now = ref.read(businessClockProvider)();
    await repository.updateOrderStatus(
      order.id,
      next,
      event: OrderEvent(
        id: '${order.id}-status-${next.name}',
        ownerId: order.ownerId,
        createdAt: now,
        orderId: order.id,
        occurredAt: now,
        kind: 'status',
        fromStatus: current.status,
        toStatus: next,
      ),
    );
  });

  Future<bool> cancel(OrderDetailData data) => _run(data.order.id, () async {
    final repository = ref.read(orderRepositoryProvider);
    final savings = ref.read(savingsRepositoryProvider);
    final result = cancelOrder(
      data.order,
      payments: data.payments,
      savings: await savings.getAllEntries(),
      correctionPrefix: '${data.order.id}-cancel',
      at: ref.read(businessClockProvider)(),
    );
    await repository.saveOrder(result.order, payments: result.payments, events: [result.event]);
    for (final entry in result.savings) {
      await savings.addEntry(entry);
    }
  });

  Future<bool> _run(String orderId, Future<void> Function() action) async {
    if (state.pending.contains(orderId)) return false;
    state = (pending: {...state.pending, orderId}, error: null);
    var ok = false;
    try {
      await action();
      ok = true;
    } on StateError {
      state = (pending: state.pending, error: 'Status order berubah. Muat ulang halaman.');
      ref.invalidate(orderDetailProvider(orderId));
    } on Exception {
      state = (pending: state.pending, error: 'Gagal menyimpan perubahan. Coba lagi.');
    } finally {
      state = (pending: {...state.pending}..remove(orderId), error: state.error);
    }
    if (ok) {
      ref.invalidate(orderDetailProvider(orderId));
      ref.invalidate(antreanDataProvider);
      ref.invalidate(receiptViewProvider(orderId));
    }
    return ok;
  }
}
