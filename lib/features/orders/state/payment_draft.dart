import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

class PaymentDraftState {
  const PaymentDraftState({this.text = '', this.method = PayMethod.tunai, this.saveExcess = false});
  final String text;
  final PayMethod method;
  final bool saveExcess;
  int get amount => int.tryParse(text) ?? 0;
}

class PaymentDraft extends Notifier<PaymentDraftState> {
  bool _fresh = false;
  @override
  PaymentDraftState build() => const PaymentDraftState();
  void start(int due) {
    state = PaymentDraftState(text: due <= 0 ? '' : '$due');
    _fresh = true;
  }

  void key(AppNumpadKeyValue key) {
    if (key == AppNumpadKeyValue.decimal) return;
    final initial = _fresh ? '' : state.text;
    _fresh = false;
    var text = switch (key) {
      AppNumpadKeyValue.backspace =>
        initial.isEmpty ? '' : initial.substring(0, initial.length - 1),
      AppNumpadKeyValue.tripleZero => initial.isEmpty ? '' : '${initial}000',
      _ => initial.length >= 9 ? initial : '$initial${key.label}',
    };
    if (text == '0') text = '';
    state = PaymentDraftState(text: text, method: state.method, saveExcess: state.saveExcess);
  }

  void setMethod(PayMethod method) => state = PaymentDraftState(text: state.text, method: method);
  void setExcess({required bool save}) =>
      state = PaymentDraftState(text: state.text, method: state.method, saveExcess: save);
}

final paymentDraftProvider = NotifierProvider<PaymentDraft, PaymentDraftState>(PaymentDraft.new);
