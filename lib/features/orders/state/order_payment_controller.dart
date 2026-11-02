import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/state/order_payment_save.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

typedef OrderPaymentState = ({bool saving, String? error});
final orderPaymentProvider = NotifierProvider<OrderPaymentAction, OrderPaymentState>(
  OrderPaymentAction.new,
);

class OrderPaymentAction extends Notifier<OrderPaymentState> {
  @override
  OrderPaymentState build() => (saving: false, error: null);
  void clearError() {
    if (!state.saving) state = (saving: false, error: null);
  }

  Future<bool> record(
    OrderDetailData data, {
    required int amount,
    required PayMethod method,
    required int received,
    bool saveExcess = false,
    bool completeOnPayment = false,
  }) async {
    if (state.saving) return false;
    if (amount <= 0 || received < amount) {
      state = (saving: false, error: 'Nominal pembayaran tidak valid.');
      return false;
    }
    state = (saving: true, error: null);
    try {
      await saveOrderPayment(
        ref,
        data.order.id,
        received: received,
        method: method,
        saveExcess: saveExcess,
        completeOnPayment: completeOnPayment,
      );
      state = (saving: false, error: null);
      ref.invalidate(orderDetailProvider(data.order.id));
      ref.invalidate(antreanDataProvider);
      ref.invalidate(receiptViewProvider(data.order.id));
      return true;
    } catch (_) {
      state = (
        saving: false,
        error: 'Gagal menyimpan pembayaran. Periksa sisa tagihan dan coba lagi.',
      );
      return false;
    }
  }
}
