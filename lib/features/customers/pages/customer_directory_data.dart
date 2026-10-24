import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/savings_rules.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/data/customer_history_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/transactions/pages/add_customer_form.dart';

class CustomerDirectoryRow {
  const CustomerDirectoryRow(
    this.customer,
    this.orderCount,
    this.historyTotal,
    this.debt,
    this.savings,
    this.paid,
  );
  final Customer customer;
  final int orderCount, historyTotal, debt, savings, paid;
}

List<CustomerDirectoryRow> filterCustomers(
  List<CustomerDirectoryRow> rows, {
  required int filter,
  required String search,
}) {
  final query = search.trim().toLowerCase();
  final phone = normalizePhone(query);
  return rows.where((row) {
    final matches =
        query.isEmpty ||
        row.customer.name.toLowerCase().contains(query) ||
        (phone.isNotEmpty && normalizePhone(row.customer.phone).contains(phone));
    return matches &&
        switch (filter) {
          1 => row.debt > 0,
          2 => row.savings > 0,
          _ => true,
        };
  }).toList();
}

final customerSummariesProvider = FutureProvider<List<CustomerDirectoryRow>>((ref) async {
  final customers = ref.watch(customerRepositoryProvider);
  final orders = ref.watch(orderRepositoryProvider);
  final savings = ref.watch(savingsRepositoryProvider);
  final people = await customers.getCustomers(includeInactive: true);
  final notes = await orders.getOrders();
  final payments = await orders.getAllPayments();
  final entries = await savings.getAllEntries();
  List<Order> active(Iterable<Order> source, String id) => source
      .where((o) => o.customerId == id && o.deletedAt == null && o.status != OrderStatus.dibatalkan)
      .toList();
  final rows = <CustomerDirectoryRow>[];
  for (final person in people) {
    final current = active(notes, person.id);
    final initial = active(orderFixtures, person.id);
    final baseline = customerHistoryFixtures[person.id];
    final total = current.fold(0, (sum, o) => sum + o.total);
    final initialTotal = initial.fold(0, (sum, o) => sum + o.total);
    rows.add(
      CustomerDirectoryRow(
        person,
        baseline == null ? current.length : baseline.orderCount + current.length - initial.length,
        baseline == null ? total : baseline.revenue + total - initialTotal,
        outstanding(current, payments),
        savingsBalance(entries, customerId: person.id),
        current
            .where((o) => o.total > paidAmount(payments, orderId: o.id))
            .fold(0, (sum, o) => sum + paidAmount(payments, orderId: o.id)),
      ),
    );
  }
  return rows;
});

final customerDirectoryProvider = FutureProvider<List<CustomerDirectoryRow>>((ref) async {
  final rows = await ref.watch(customerSummariesProvider.future);
  return rows.where((row) => row.customer.isActive).toList();
});
