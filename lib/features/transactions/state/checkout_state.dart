import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/transactions/state/checkout_save.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

enum PaymentMode { lunas, dp, belumBayar }

class CheckoutState {
  const CheckoutState({
    this.method = PayMethod.tunai,
    this.mode = PaymentMode.lunas,
    this.received = 0,
    this.useSavings = false,
    this.saving = false,
    this.error,
  });
  final PayMethod method;
  final PaymentMode mode;
  final int received;
  final bool useSavings, saving;
  final String? error;
  CheckoutState copyWith({
    PayMethod? method,
    PaymentMode? mode,
    int? received,
    bool? useSavings,
    bool? saving,
    String? error,
    bool clearError = false,
  }) => CheckoutState(
    method: method ?? this.method,
    mode: mode ?? this.mode,
    received: received ?? this.received,
    useSavings: useSavings ?? this.useSavings,
    saving: saving ?? this.saving,
    error: clearError ? null : error ?? this.error,
  );
}

final checkoutControllerProvider = NotifierProvider<Checkout, CheckoutState>(Checkout.new);

class Checkout extends Notifier<CheckoutState> {
  @override
  CheckoutState build() => const CheckoutState();

  void setMethod(PayMethod method) => state = state.copyWith(method: method, clearError: true);

  void setMode(PaymentMode mode, {required int due}) => state = state.copyWith(
    mode: mode,
    received: switch (mode) {
      PaymentMode.lunas => due,
      PaymentMode.dp => due ~/ 2,
      PaymentMode.belumBayar => 0,
    },
    clearError: true,
  );

  void setSavings({required bool value, required int due}) => state = state.copyWith(
    useSavings: value,
    received: state.mode == PaymentMode.lunas ? due : state.received,
    clearError: true,
  );

  void setReceived(int value, {required int due}) => state = state.copyWith(
    received: value,
    mode: value >= due
        ? PaymentMode.lunas
        : value <= 0
        ? PaymentMode.belumBayar
        : PaymentMode.dp,
    clearError: true,
  );

  Future<String?> save() async {
    final draft = ref.read(transactionDraftProvider);
    if (draft.customerId == null) return 'Pilih pelanggan terlebih dahulu.';
    if (draft.lines.isEmpty) return 'Tambahkan layanan terlebih dahulu.';
    state = state.copyWith(saving: true, clearError: true);
    try {
      final orderId = await saveCheckout(ref, draft, state);
      ref.read(transactionDraftProvider.notifier).clear();
      state = const CheckoutState();
      return orderId;
    } on Object catch (error) {
      state = state.copyWith(saving: false, error: 'Gagal menyimpan nota: $error');
      return null;
    }
  }
}
