import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/transactions/state/checkout_data.dart';
import 'package:laurum/features/transactions/state/checkout_save.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
export 'package:laurum/features/transactions/state/checkout_data.dart';

final checkoutControllerProvider = NotifierProvider<Checkout, CheckoutState>(Checkout.new);

class Checkout extends Notifier<CheckoutState> {
  @override
  CheckoutState build() => const CheckoutState();
  void setMethod(PayMethod method) => state = state.copyWith(method: method, saveExcess: false);
  void setTerm(PayTerm term) => state = state.copyWith(payTerm: term, saveExcess: false);
  void setExcess({required bool save}) => state = state.copyWith(saveExcess: save);
  void setSavings({required bool value, int? due}) => state = state.copyWith(useSavings: value);
  void setReceived(int value, {int? due}) => state = state.copyWith(received: value);
  Future<String?> save() async {
    if (state.saving) return null;
    final draft = ref.read(transactionDraftProvider);
    if (draft.customerId == null || draft.lines.isEmpty) return null;
    state = state.copyWith(saving: true);
    try {
      final orderId = await saveCheckout(ref, draft, state);
      ref.read(transactionDraftProvider.notifier).clear();
      state = const CheckoutState();
      return orderId;
    } catch (_) {
      state = state.copyWith(
        saving: false,
        error: 'Gagal menyimpan nota. Periksa pembayaran dan coba lagi.',
      );
      return null;
    }
  }
}
