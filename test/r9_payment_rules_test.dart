import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/features/orders/state/payment_label.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';

import 'r9_order_fixture.dart';

void main() {
  test('completion hold depends on COD and remaining balance', () {
    for (final term in PayTerm.values) {
      for (final paid in [0, 4000, 10000, 11000]) {
        final order = r9Order(term: term);
        expect(isCompletionHeld(order, paid), term == PayTerm.cod && paid < 10000);
        expect(order.withStatus(OrderStatus.siap).payTerm, term);
      }
    }
    expect(isCompletionHeld(r9Order(term: PayTerm.cod, total: 0), 0), isFalse);
    expect(r9Order().payTerm, PayTerm.sekarang);
    expect(r9Order(), isNot(r9Order(term: PayTerm.cod)));
  });
  test('one label mapping covers COD, partial, unpaid legacy and paid', () {
    expect(paymentLabel(r9Order(), 0), 'Sisa Rp10.000');
    expect(paymentLabel(r9Order(), 4000), 'Sisa Rp6.000');
    expect(paymentLabel(r9Order(term: PayTerm.cod), 4000), 'COD - sisa Rp6.000');
    expect(paymentLabel(r9Order(term: PayTerm.cod), 10000), 'Lunas');
  });
  test('checkout defaults to due; explicit zero stays zero and is invalid', () {
    final initial = quotePayment(total: 10000, balance: 0, state: const CheckoutState());
    expect(initial.received, 10000);
    final zero = quotePayment(total: 10000, balance: 0, state: const CheckoutState(received: 0));
    expect(zero.received, 0);
    expect(zero.valid, isFalse);
    for (final input in [0, -1]) {
      expect(
        quotePayment(
          total: 10000,
          balance: 4000,
          state: CheckoutState(received: input, useSavings: true),
        ).valid,
        isFalse,
      );
    }
    expect(
      quotePayment(
        total: 10000,
        balance: 10000,
        state: const CheckoutState(received: 0, useSavings: true),
      ).valid,
      isTrue,
    );
    expect(
      quotePayment(
        total: 10000,
        balance: 0,
        state: const CheckoutState(method: PayMethod.tabungan),
      ).valid,
      isFalse,
    );
    final cod = quotePayment(
      total: 10000,
      balance: 4000,
      state: const CheckoutState(payTerm: PayTerm.cod, useSavings: true),
    );
    expect(cod.cashPaid, 0);
    expect(cod.savingsUsed, 4000);
    expect(cod.outstanding, 6000);
    expect(cod.valid, isTrue);
  });
  test('cash allocation applies invoice only and optionally deposits excess', () {
    for (final save in [false, true]) {
      final quote = quotePayment(
        total: 10000,
        balance: 0,
        state: CheckoutState(received: 15000, saveExcess: save),
      );
      expect(quote.cashPaid, 10000);
      expect(quote.change, save ? 0 : 5000);
      expect(quote.deposit, save ? 5000 : 0);
    }
  });
}
