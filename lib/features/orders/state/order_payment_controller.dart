import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

typedef OrderPaymentState = ({bool saving, String? error});
final orderPaymentProvider = NotifierProvider<OrderPaymentAction, OrderPaymentState>(
  OrderPaymentAction.new,
);

class OrderPaymentAction extends Notifier<OrderPaymentState> {
  @override
  OrderPaymentState build() => (saving: false, error: null);

  Future<bool> record(
    OrderDetailData data, {
    required int amount,
    required PayMethod method,
    required int received,
  }) async {
    if (state.saving) return false;
    if (amount <= 0 || amount > data.outstanding) {
      state = (saving: false, error: 'Nominal pembayaran tidak valid.');
      return false;
    }
    state = (saving: true, error: null);
    final repository = ref.read(orderRepositoryProvider);
    final current = await repository.getOrderById(data.order.id);
    final existing = await repository.getPaymentsByOrderId(data.order.id);
    final due = current == null ? 0 : current.total - paidAmount(existing, orderId: current.id);
    if (current == null || current.status == OrderStatus.dibatalkan || amount > due) {
      state = (saving: false, error: 'Nominal pembayaran melebihi sisa piutang.');
      return false;
    }
    final now = ref.read(businessClockProvider)();
    final count = existing.length + 1;
    try {
      await repository.saveOrder(
        current,
        payments: [
          Payment(
            id: '${current.id}-payment-$count',
            ownerId: current.ownerId,
            createdAt: now,
            orderId: current.id,
            method: method,
            amount: amount,
            received: received < amount ? amount : received,
            paidAt: now,
          ),
        ],
        events: [
          OrderEvent(
            id: '${current.id}-event-payment-$count',
            ownerId: current.ownerId,
            createdAt: now,
            orderId: current.id,
            occurredAt: now,
            kind: 'payment',
            note: 'Pembayaran ${Formatters.rupiah(amount)}',
          ),
        ],
      );
      state = (saving: false, error: null);
      ref.invalidate(orderDetailProvider(data.order.id));
      ref.invalidate(antreanDataProvider);
      ref.invalidate(receiptViewProvider(data.order.id));
      return true;
    } on Exception {
      state = (saving: false, error: 'Gagal menyimpan pembayaran. Coba lagi.');
      return false;
    }
  }
}
