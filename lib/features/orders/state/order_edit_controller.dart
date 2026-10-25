import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/state/order_edit_item.dart';
import 'package:laurum/features/orders/state/order_edit_order.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

class OrderEditState {
  const OrderEditState({required this.order, this.saving = false, this.error});
  final Order order;
  final bool saving;
  final String? error;
}

final orderEditProvider = AsyncNotifierProvider.autoDispose
    .family<OrderEdit, OrderEditState, String>(OrderEdit.new);

class OrderEdit extends AsyncNotifier<OrderEditState> {
  OrderEdit(this.orderId);
  final String orderId;

  @override
  Future<OrderEditState> build() async {
    final repository = ref.read(orderRepositoryProvider);
    final order = await repository.getOrderById(orderId);
    if (order == null) throw StateError('Order tidak ditemukan');
    if (order.status == OrderStatus.selesai || order.status == OrderStatus.dibatalkan) {
      throw StateError('Nota final tidak dapat diedit');
    }
    final items = await repository.getItemsByOrderId(orderId);
    final services = await ref.read(serviceRepositoryProvider).getServices(includeInactive: true);
    final draft = ref.read(transactionDraftProvider.notifier)
      ..clear()
      ..selectCustomer(order.customerId);
    for (final item in items) {
      final service = services.where((service) => service.id == item.serviceId).firstOrNull;
      if (service == null) continue;
      draft.add(service);
      draft.setQuantity(service.id, item.qtyMilli);
    }
    draft.setDiscount(order.discount);
    draft.setNote(order.note);
    return OrderEditState(order: order);
  }

  Future<bool> save() async {
    final data = state.value;
    if (data == null || data.saving) return false;
    final draft = ref.read(transactionDraftProvider);
    state = AsyncData(OrderEditState(order: data.order, saving: true));
    try {
      if (draft.lines.isEmpty) throw ArgumentError('Layanan kosong');
      final repository = ref.read(orderRepositoryProvider);
      final paid = paidAmount(await repository.getPaymentsByOrderId(orderId), orderId: orderId);
      if (draft.total < paid) throw StateError('Total di bawah pembayaran');
      final currentItems = await repository.getItemsByOrderId(orderId);
      final events = await repository.getEventsByOrderId(orderId);
      final now = ref.read(businessClockProvider)();
      final order = orderEditOrder(data.order, draft, now);
      await repository.saveOrder(
        order,
        items: [
          for (final line in draft.lines) orderEditItem(line, order, currentItems, now),
        ],
        events: [
          OrderEvent(
            id: '${order.id}-edited-${events.length + 1}',
            ownerId: order.ownerId,
            createdAt: now,
            orderId: order.id,
            occurredAt: now,
            kind: 'edited',
          ),
        ],
      );
      state = AsyncData(OrderEditState(order: order));
      ref.invalidate(orderDetailProvider(orderId));
      ref.invalidate(antreanDataProvider);
      ref.invalidate(receiptViewProvider(orderId));
      return true;
    } on ArgumentError {
      return _fail(data.order, 'Tambahkan minimal satu layanan.');
    } on StateError {
      return _fail(data.order, 'Total tagihan tidak boleh lebih kecil dari pembayaran tercatat.');
    } on Exception {
      return _fail(data.order, 'Gagal menyimpan perubahan. Coba lagi.');
    }
  }

  bool _fail(Order order, String message) {
    state = AsyncData(OrderEditState(order: order, error: message));
    return false;
  }
}
