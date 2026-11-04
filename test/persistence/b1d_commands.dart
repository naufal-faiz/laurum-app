import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/features/orders/state/order_completion_save.dart';
import 'package:laurum/features/orders/state/order_payment_save.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

import 'b1d_harness.dart';

final paymentCommand = Provider(
  (ref) =>
      (String id, int received, {bool saveExcess = false, bool complete = false}) =>
          saveOrderPayment(
            ref,
            id,
            received: received,
            method: PayMethod.tunai,
            saveExcess: saveExcess,
            completeOnPayment: complete,
          ),
);
final completionCommand = Provider(
  (ref) =>
      (Order order) => saveOrderCompletion(ref, order),
);
Future<String?> checkout(
  B1dHarness h, {
  PayTerm term = PayTerm.cod,
  int? received,
  bool savings = false,
  bool excess = false,
}) async {
  h.scope.read(transactionDraftProvider.notifier)
    ..clear()
    ..selectCustomer(h.customerId)
    ..add(h.service);
  h.scope.invalidate(checkoutControllerProvider);
  final controller = h.scope.read(checkoutControllerProvider.notifier)..setTerm(term);
  controller.setSavings(value: savings);
  controller.setExcess(save: excess);
  if (received != null) controller.setReceived(received);
  return controller.save();
}
