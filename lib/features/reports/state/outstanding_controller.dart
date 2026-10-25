import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

class PaymentRecordState {
  const PaymentRecordState({
    this.text = '',
    this.busy = false,
    this.error,
  });
  final String text;
  final bool busy;
  final String? error;
  int get amount => int.tryParse(text) ?? 0;

  PaymentRecordState withInput({String? text}) => PaymentRecordState(
    text: text ?? this.text,
    busy: busy,
  );

  PaymentRecordState withStatus({bool? busy, String? error}) => PaymentRecordState(
    text: text,
    busy: busy ?? this.busy,
    error: error,
  );
}

final paymentRecordProvider =
    NotifierProvider.family<PaymentRecordController, PaymentRecordState, String>(
      PaymentRecordController.new,
    );

class PaymentRecordController extends Notifier<PaymentRecordState> {
  PaymentRecordController(this.orderId);
  final String orderId;

  @override
  PaymentRecordState build() => const PaymentRecordState();

  void key(AppNumpadKeyValue key) {
    final value = state.text;
    final String text;
    if (key == AppNumpadKeyValue.backspace) {
      text = value.isEmpty ? '' : value.substring(0, value.length - 1);
    } else if (key == AppNumpadKeyValue.tripleZero) {
      text = value.isEmpty || value == '0' || value.length > 6 ? value : '${value}000';
    } else if (key == AppNumpadKeyValue.decimal) {
      return;
    } else {
      text = value.length >= 9
          ? value
          : value == '0'
          ? key.label
          : '$value${key.label}';
    }
    state = state.withInput(text: text);
  }

  Future<bool> save(int maxAmount) async {
    if (state.busy) return false;
    final amount = state.amount;
    if (amount <= 0 || amount > maxAmount) {
      state = state.withStatus(error: 'Nominal pembayaran tidak valid.');
      return false;
    }
    state = state.withStatus(busy: true);
    try {
      final now = ref.read(businessClockProvider)();
      await ref
          .read(orderRepositoryProvider)
          .addPayment(
            Payment(
              id: 'pay-${now.microsecondsSinceEpoch}',
              ownerId: ref.read(authServiceProvider).currentUserId ?? 'owner',
              createdAt: now,
              orderId: orderId,
              method: PayMethod.tunai,
              amount: amount,
              received: amount,
              paidAt: now,
            ),
          );
      state = state.withStatus(busy: false);
      return true;
    } catch (_) {
      state = state.withStatus(busy: false, error: 'Catat bayar gagal. Coba lagi.');
      return false;
    }
  }
}
