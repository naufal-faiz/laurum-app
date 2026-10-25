import 'package:laurum/core/domain/domain_enums.dart';

const depositMethods = [PayMethod.tunai, PayMethod.qris, PayMethod.transfer];
const depositMethodLabels = ['Tunai', 'QRIS', 'Transfer'];

class CustomerDepositState {
  const CustomerDepositState({
    this.text = '',
    this.method = PayMethod.tunai,
    this.note = '',
    this.busy = false,
    this.error,
    this.nominalError,
  });
  final String text;
  final PayMethod method;
  final String note;
  final bool busy;
  final String? error, nominalError;
  int get amount => int.tryParse(text) ?? 0;

  CustomerDepositState withInput({String? text, PayMethod? method, String? note}) =>
      CustomerDepositState(
        text: text ?? this.text,
        method: method ?? this.method,
        note: note ?? this.note,
        busy: busy,
      );

  CustomerDepositState withStatus({bool? busy, String? error, String? nominalError}) =>
      CustomerDepositState(
        text: text,
        method: method,
        note: note,
        busy: busy ?? this.busy,
        error: error,
        nominalError: nominalError,
      );
}
