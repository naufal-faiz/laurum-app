import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/services/repository_providers.dart';

class OutstandingRow {
  const OutstandingRow(this.order, this.customer, this.paid, this.outstandingAmount);
  final Order order;
  final Customer customer;
  final int paid;
  final int outstandingAmount;
  PayStatus get status => payStatus(total: order.total, paid: paid);
  String get statusLabel => status == PayStatus.belumBayar ? 'Belum bayar' : 'DP ${paid ~/ 1000}k';
}

class OutstandingListData {
  const OutstandingListData(this.rows);
  final List<OutstandingRow> rows;
  int get totalOutstanding => rows.fold(0, (sum, r) => sum + r.outstandingAmount);
  int get unpaidCount => rows.where((r) => r.status == PayStatus.belumBayar).length;
  int get dpCount => rows.where((r) => r.status == PayStatus.dp).length;
  int get customerCount => {...rows.map((r) => r.customer.id)}.length;
}

List<OutstandingRow> filterOutstanding(List<OutstandingRow> rows, int filter) {
  if (filter == 1) return rows.where((r) => r.status == PayStatus.belumBayar).toList();
  if (filter == 2) return rows.where((r) => r.status == PayStatus.dp).toList();
  return rows;
}

final outstandingListProvider = FutureProvider<OutstandingListData>((ref) async {
  final orders = await ref.watch(orderRepositoryProvider).getOrders();
  final customers = await ref.watch(customerRepositoryProvider).getCustomers(includeInactive: true);
  final payments = await ref.watch(orderRepositoryProvider).getAllPayments();

  final customerMap = {for (final c in customers) c.id: c};
  final active = orders
      .where((o) => o.deletedAt == null && o.status != OrderStatus.dibatalkan)
      .toList();

  final rows = <OutstandingRow>[];
  for (final order in active) {
    final paid = paidAmount(payments, orderId: order.id);
    final outst = (order.total - paid).clamp(0, order.total);
    if (outst > 0) {
      final customer = customerMap[order.customerId];
      if (customer != null) {
        rows.add(OutstandingRow(order, customer, paid, outst));
      }
    }
  }

  rows.sort((a, b) => a.order.createdAt.compareTo(b.order.createdAt));
  return OutstandingListData(rows);
});

final outstandingFilterProvider = NotifierProvider<OutstandingFilter, int>(
  OutstandingFilter.new,
);

class OutstandingFilter extends Notifier<int> {
  @override
  int build() => 0;
  void select(int index) => state = index;
}
