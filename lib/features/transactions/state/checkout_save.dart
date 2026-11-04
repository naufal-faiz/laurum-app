import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/payment_excess.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/domain/savings_rules.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/checkout_item.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

Future<String> saveCheckout(
  Ref ref,
  TransactionDraftState draft,
  CheckoutState state,
) => ref.read(transactionRunnerProvider).run(() async {
  final orderRepository = ref.read(orderRepositoryProvider);
  final savingsRepository = ref.read(savingsRepositoryProvider);
  final profile = await ref.read(businessRepositoryProvider).getProfile();
  final customerId = draft.customerId!;
  final customer = await ref.read(customerRepositoryProvider).getCustomerById(customerId);
  if (customer == null) throw StateError('Pelanggan tidak ditemukan');
  final balance = await savingsRepository.getBalance(customerId);
  final total = draft.total;
  final quote = quotePayment(total: total, balance: balance, state: state);
  if (!quote.valid) throw StateError('Isi jumlah atau pilih Bayar nanti (COD)');
  final savingsUsed = quote.savingsUsed, cashPaid = quote.cashPaid;
  final now = ref.read(businessClockProvider)();
  final orders = await orderRepository.getOrders();
  final ids = ref.read(idGeneratorProvider);
  final orderNo = await ref
      .read(orderNumberGeneratorProvider)
      .reserveOrderNo(orders.map((o) => o.orderNo));
  final orderId = ids.newId();
  final cashPaymentId = ids.newId();
  final order = Order(
    id: orderId,
    ownerId: customer.ownerId,
    createdAt: now,
    orderNo: orderNo,
    customerId: customerId,
    status: initialOrderStatus(OrderSource.kasir, useOrderStatus: profile.useOrderStatus),
    source: OrderSource.kasir,
    payTerm: state.payTerm,
    discount: draft.discount,
    enteredAt: now,
    estimatedAt: estimateReady(now, draft.lines.map((line) => line.service)),
    subtotal: draft.subtotal,
    total: total,
    note: draft.note,
  );
  final items = [
    for (final line in draft.lines) checkoutItem(orderId, customer.ownerId, now, line, ids),
  ];
  final payments = <Payment>[];
  final entries = <SavingsEntry>[];
  if (savingsUsed > 0) {
    final applied = applySavings(
      order,
      payments: const [],
      savings: await savingsRepository.getAllEntries(),
      amount: savingsUsed,
      paymentId: ids.newId(),
      savingsId: ids.newId(),
      at: now,
    );
    payments.add(applied.payment);
    entries.add(applied.savings);
  }
  if (cashPaid > 0) {
    payments.add(
      checkoutCashPayment(cashPaymentId, order, state.method, cashPaid, quote.received),
    );
  }
  if (quote.deposit > 0) {
    entries.add(
      paymentExcess(order, paymentId: cashPaymentId, amount: quote.deposit, at: now, ids: ids),
    );
  }
  await orderRepository.saveOrder(
    order,
    useOrderStatus: profile.useOrderStatus,
    items: items,
    payments: payments,
    events: [checkoutCreatedEvent(order, now, ids)],
  );
  for (final entry in entries) {
    await savingsRepository.addEntry(entry);
  }
  return orderId;
});
