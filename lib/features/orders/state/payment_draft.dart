import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

class PaymentDraftState {
  const PaymentDraftState({this.text = '', this.method = PayMethod.tunai});
  final String text;
  final PayMethod method;
  int get amount => int.tryParse(text) ?? 0;
}

class PaymentDraft extends Notifier<PaymentDraftState> {
  @override
  PaymentDraftState build() => const PaymentDraftState();

  void start(int due) => state = PaymentDraftState(text: due <= 0 ? '' : '$due');

  void key(AppNumpadKeyValue key) {
    final text = switch (key) {
      AppNumpadKeyValue.backspace =>
        state.text.isEmpty ? '' : state.text.substring(0, state.text.length - 1),
      AppNumpadKeyValue.tripleZero =>
        state.text.isEmpty || state.text == '0' ? '' : '${state.text}000',
      AppNumpadKeyValue.decimal => state.text,
      _ => state.text == '0' ? key.label : '${state.text}${key.label}',
    };
    state = PaymentDraftState(text: text, method: state.method);
  }

  void setMethod(PayMethod method) => state = PaymentDraftState(text: state.text, method: method);
}

final paymentDraftProvider = NotifierProvider<PaymentDraft, PaymentDraftState>(PaymentDraft.new);
