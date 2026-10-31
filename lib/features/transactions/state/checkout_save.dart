import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_number_generator.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/domain/savings_rules.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/checkout_item.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

Future<String> saveCheckout(
  Ref ref,
  TransactionDraftState draft,
  CheckoutState state,
) async {
  final orderRepository = ref.read(orderRepositoryProvider);
  final savingsRepository = ref.read(savingsRepositoryProvider);
  final profile = await ref.read(businessRepositoryProvider).getProfile();
  final customerId = draft.customerId!;
  final customer = await ref.read(customerRepositoryProvider).getCustomerById(customerId);
  if (customer == null) throw StateError('Pelanggan tidak ditemukan');
  final balance = await savingsRepository.getBalance(customerId);
  final total = draft.total;
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
  final now = ref.read(businessClockProvider)();
  final orders = await orderRepository.getOrders();
  final orderNo = const OrderNumberGenerator().nextOrderNo(orders.map((o) => o.orderNo));
  final orderId = 'ord-${orderNo.substring(2)}';
  final order = Order(
    id: orderId,
    ownerId: customer.ownerId,
    createdAt: now,
    orderNo: orderNo,
    customerId: customerId,
    status: initialOrderStatus(OrderSource.kasir, useOrderStatus: profile.useOrderStatus),
    source: OrderSource.kasir,
    discount: draft.discount,
    enteredAt: now,
    estimatedAt: estimateReady(now, draft.lines.map((line) => line.service)),
    subtotal: draft.subtotal,
    total: total,
    note: draft.note,
  );
  final items = [
    for (final line in draft.lines) checkoutItem(orderId, customer.ownerId, now, line),
  ];
  final payments = <Payment>[];
  final entries = <SavingsEntry>[];
  if (savingsUsed > 0) {
    final applied = applySavings(
      order,
      payments: const [],
      savings: await savingsRepository.getAllEntries(),
      amount: savingsUsed,
      paymentId: '$orderId-pay-savings',
      savingsId: '$orderId-savings',
      at: now,
    );
    payments.add(applied.payment);
    entries.add(applied.savings);
  }
  if (cashPaid > 0) {
    payments.add(
      Payment(
        id: '$orderId-pay-cash',
        ownerId: customer.ownerId,
        createdAt: now,
        orderId: orderId,
        method: state.method,
        amount: cashPaid,
        received: received,
        paidAt: now,
      ),
    );
  }
  await orderRepository.saveOrder(
    order,
    useOrderStatus: profile.useOrderStatus,
    items: items,
    payments: payments,
    events: [checkoutCreatedEvent(order, now)],
  );
  for (final entry in entries) {
    await savingsRepository.addEntry(entry);
  }
  return orderId;
}
