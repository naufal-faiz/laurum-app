import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/transactions/state/checkout_data.dart';

typedef PaymentQuote = ({
  int savingsUsed,
  int due,
  int cashPaid,
  int received,
  int change,
  int deposit,
  int outstanding,
  bool valid,
});
PaymentQuote quotePayment({
  required int total,
  required int balance,
  required CheckoutState state,
}) {
  final savingsUsed = state.useSavings ? balance.clamp(0, total) : 0;
  final due = total - savingsUsed;
  final cod = state.payTerm == PayTerm.cod;
  final entered = state.received ?? due;
  final received = cod || entered < 0 ? 0 : entered;
  final paid = received.clamp(0, due);
  final extra = state.method == PayMethod.tunai ? (received - paid).clamp(0, received) : 0;
  return (
    savingsUsed: savingsUsed,
    due: due,
    cashPaid: paid,
    received: received,
    change: state.saveExcess ? 0 : extra,
    deposit: state.saveExcess ? extra : 0,
    outstanding: due - paid,
    valid:
        cod ||
        ((received > 0 || (due == 0 && savingsUsed > 0)) &&
            (state.method != PayMethod.tabungan || due == 0) &&
            (state.method == PayMethod.tunai || received <= due)),
  );
}
