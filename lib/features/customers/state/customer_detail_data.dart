import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/nota_history_data.dart';

typedef CustomerMovement = ({SavingsEntry entry, int balance});

class CustomerDetailData {
  const CustomerDetailData(this.summary, this.history, this.movements);
  final CustomerDirectoryRow summary;
  final NotaHistoryData history;
  final List<CustomerMovement> movements;
  List<Order> get orders => history.orders
      .where((o) => o.customerId == summary.customer.id && o.deletedAt == null)
      .take(3)
      .toList();
}

List<CustomerMovement> savingsMovements(List<SavingsEntry> entries) {
  final chronological = entries.toList()
    ..sort((a, b) {
      final byTime = a.createdAt.compareTo(b.createdAt);
      return byTime != 0 ? byTime : a.id.compareTo(b.id);
    });
  var balance = 0;
  final rows = <CustomerMovement>[];
  for (final entry in chronological) {
    balance += entry.kind == SavingsKind.pakai ? -entry.amount : entry.amount;
    rows.add((entry: entry, balance: balance));
  }
  return rows.reversed.toList();
}

List<CustomerMovement> customerMovements(List<SavingsEntry> entries) =>
    savingsMovements(entries).take(3).toList();

final customerDetailProvider = FutureProvider.family<CustomerDetailData?, String>((ref, id) async {
  final summaries = ref.watch(customerSummariesProvider.future);
  final history = ref.watch(notaHistoryProvider.future);
  final savings = ref.watch(savingsRepositoryProvider);
  final summary = (await summaries).where((row) => row.customer.id == id).firstOrNull;
  if (summary == null) return null;
  return CustomerDetailData(
    summary,
    await history,
    customerMovements(await savings.getEntriesByCustomerId(id)),
  );
});
