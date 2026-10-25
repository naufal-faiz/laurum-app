import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';

typedef PaymentQuote = ({
  int savingsUsed,
  int due,
  int cashPaid,
  int received,
  int change,
});

PaymentQuote quotePayment({
  required int total,
  required int balance,
  required CheckoutState state,
}) {
  final savingsUsed = state.useSavings ? (balance < total ? balance : total) : 0;
  final due = total - savingsUsed;
  final cashPaid = switch (state.mode) {
    PaymentMode.lunas => due,
    PaymentMode.dp => state.received < due ? state.received : due,
    PaymentMode.belumBayar => 0,
  };
  final received = state.method == PayMethod.tunai
      ? (state.received == 0 ? cashPaid : state.received)
      : cashPaid;
  return (
    savingsUsed: savingsUsed,
    due: due,
    cashPaid: cashPaid,
    received: received,
    change: state.method == PayMethod.tunai && received > cashPaid ? received - cashPaid : 0,
  );
}
