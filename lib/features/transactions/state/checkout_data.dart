import 'package:laurum/core/domain/domain_enums.dart';

class CheckoutState {
  const CheckoutState({
    this.method = PayMethod.tunai,
    this.payTerm = PayTerm.sekarang,
    this.received,
    this.useSavings = false,
    this.saveExcess = false,
    this.saving = false,
    this.error,
  });
  final PayMethod method;
  final PayTerm payTerm;
  final int? received;
  final bool useSavings, saveExcess, saving;
  final String? error;
  CheckoutState copyWith({
    PayMethod? method,
    PayTerm? payTerm,
    int? received,
    bool? useSavings,
    bool? saveExcess,
    bool? saving,
    String? error,
  }) => CheckoutState(
    method: method ?? this.method,
    payTerm: payTerm ?? this.payTerm,
    received: received ?? this.received,
    useSavings: useSavings ?? this.useSavings,
    saveExcess: saveExcess ?? this.saveExcess,
    saving: saving ?? this.saving,
    error: error,
  );
}
