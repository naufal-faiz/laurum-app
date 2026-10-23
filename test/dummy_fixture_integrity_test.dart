import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/order_item_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';

void main() {
  test('all order relationships and integer totals agree with master services', () {
    final customers = customerFixtures.map((c) => c.id).toSet();
    final orders = orderFixtures.map((o) => o.id).toSet();
    expect(orders.length, orderFixtures.length);
    expect(orderFixtures.map((o) => o.orderNo).toSet().length, orderFixtures.length);
    expect(orders, isNot(contains('ord-0143')));
    for (final order in orderFixtures) {
      expect(customers, contains(order.customerId));
      final items = orderItemFixtures.where((i) => i.orderId == order.id);
      expect(orderTotal(items, discount: order.discount), order.total);
      final services = items.map((i) => serviceFixtures.singleWhere((s) => s.id == i.serviceId));
      expect(estimateReady(order.enteredAt, services), order.estimatedAt);
      for (final item in items) {
        expect(lineTotal(qtyMilli: item.qtyMilli, unitPrice: item.unitPrice), item.lineTotal);
      }
    }
    for (final payment in paymentFixtures) {
      expect(orders, contains(payment.orderId));
    }
    for (final saving in savingsFixtures.where((s) => s.orderId != null)) {
      expect(orders, contains(saving.orderId));
      expect(
        paymentFixtures
            .where((p) => p.orderId == saving.orderId && p.method == PayMethod.tabungan)
            .fold<int>(0, (s, p) => s + p.amount),
        saving.amount,
      );
    }
  });

  test('pending cancellation points at an actionable order, not a final one', () {
    final proposal = proposalFixtures.singleWhere((p) => p.id == 'prop-001');
    expect(proposal.status, ProposalStatus.menunggu);
    final order = orderFixtures.singleWhere((o) => o.id == proposal.orderId);
    expect(order.status, OrderStatus.menungguJemput);
    expect(nextStatus(order.status, cancel: true), OrderStatus.dibatalkan);
  });
}
