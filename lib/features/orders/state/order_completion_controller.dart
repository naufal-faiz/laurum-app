import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/orders/state/order_completion_save.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

typedef OrderCompletionState = ({bool busy, String? error});
final orderCompletionProvider =
    NotifierProvider.family<OrderCompletion, OrderCompletionState, String>(OrderCompletion.new);

class OrderCompletion extends Notifier<OrderCompletionState> {
  OrderCompletion(this._id);
  final String _id;
  @override
  OrderCompletionState build() {
    return (busy: false, error: null);
  }

  Future<bool> complete() async {
    if (state.busy) return false;
    state = (busy: true, error: null);
    try {
      final order = await loadCompletableOrder(ref, _id);
      // Fetch a fresh receipt after any payment/edit made since the last print.
      ref.invalidate(receiptViewProvider(_id));
      final view = await ref.read(receiptViewProvider(_id).future);
      if (view == null || view.order != order) throw StateError('Receipt changed');
      final ok = await ref.read(receiptPrintProvider.notifier).printReceipt(view);
      if (!ok) {
        return _fail(ref.read(receiptPrintProvider).error ?? 'Cetak belum berhasil.');
      }
      await saveOrderCompletion(ref, order);
      state = (busy: false, error: null);
      return true;
    } on StateError {
      ref.invalidate(orderDetailProvider(_id));
      return _fail('Order atau pengaturan berubah. Muat ulang halaman.');
    } on Exception {
      return _fail('Gagal menyelesaikan order. Coba lagi.');
    }
  }

  bool _fail(String message) {
    state = (busy: false, error: message);
    return false;
  }
}
