import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/orders/state/payment_draft.dart';
import 'package:laurum/features/transactions/state/cash_input.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

void main() {
  test('both payment numpads replace initial value and clear it with backspace', () {
    final scope = ProviderContainer();
    addTearDown(scope.dispose);
    final cash = scope.read(cashInputProvider.notifier);
    cash.start(25000);
    cash.key(AppNumpadKeyValue.five);
    expect(scope.read(cashInputProvider), '5');
    cash.start(25000);
    cash.key(AppNumpadKeyValue.backspace);
    expect(scope.read(cashInputProvider), '');
    cash.key(AppNumpadKeyValue.zero);
    cash.key(AppNumpadKeyValue.five);
    expect(scope.read(cashInputProvider), '5');
    final payment = scope.read(paymentDraftProvider.notifier);
    payment.start(25000);
    payment.key(AppNumpadKeyValue.five);
    expect(scope.read(paymentDraftProvider).text, '5');
    payment.start(25000);
    payment.key(AppNumpadKeyValue.backspace);
    expect(scope.read(paymentDraftProvider).text, '');
    payment.key(AppNumpadKeyValue.zero);
    payment.key(AppNumpadKeyValue.five);
    expect(scope.read(paymentDraftProvider).text, '5');
  });
}
