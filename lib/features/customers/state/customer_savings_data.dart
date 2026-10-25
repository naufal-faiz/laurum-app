import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_detail_data.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';

class CustomerSavingsData {
  const CustomerSavingsData(this.summary, this.movements, this.orders);
  final CustomerDirectoryRow summary;
  final List<CustomerMovement> movements;
  final Map<String, Order> orders;
  int get deposits => movements.where((row) => row.entry.kind == SavingsKind.setor).length;
  int get spendings => movements.where((row) => row.entry.kind == SavingsKind.pakai).length;
  String? orderNumber(String? orderId) => orderId == null ? null : orders[orderId]?.orderNo;
}

String savingsLabel(SavingsEntry entry, String? orderNo) => switch (entry.kind) {
  SavingsKind.setor => 'Setoran tunai',
  SavingsKind.pakai => orderNo == null ? 'Dipakai untuk nota' : 'Dipakai nota $orderNo',
  SavingsKind.penyesuaian => 'Penyesuaian tabungan',
};

String savingsMethodLabel(PayMethod method) => switch (method) {
  PayMethod.tunai => 'Tunai',
  PayMethod.qris => 'QRIS',
  PayMethod.transfer => 'Transfer',
  PayMethod.tabungan => 'Tabungan',
};

String? savingsNote(SavingsEntry entry) {
  final note = entry.note.trim();
  if (note.isEmpty) return null;
  final lower = note.toLowerCase();
  if (entry.kind == SavingsKind.setor && lower.startsWith('setoran')) return null;
  if (entry.kind == SavingsKind.pakai && lower.startsWith('dipakai')) return null;
  return note;
}

List<CustomerMovement> filterSavings(List<CustomerMovement> rows, int filter) => switch (filter) {
  1 => rows.where((row) => row.entry.kind == SavingsKind.setor).toList(),
  2 => rows.where((row) => row.entry.kind == SavingsKind.pakai).toList(),
  _ => rows,
};

final customerSavingsProvider = FutureProvider.family<CustomerSavingsData?, String>((
  ref,
  id,
) async {
  final summaries = await ref.watch(customerSummariesProvider.future);
  final summary = summaries.where((row) => row.customer.id == id).firstOrNull;
  if (summary == null) return null;
  final entries = await ref.watch(savingsRepositoryProvider).getEntriesByCustomerId(id);
  final orders = await ref.watch(orderRepositoryProvider).getOrders();
  return CustomerSavingsData(summary, savingsMovements(entries), {
    for (final order in orders) order.id: order,
  });
});
