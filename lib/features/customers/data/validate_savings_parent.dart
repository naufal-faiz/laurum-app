import 'package:drift/drift.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/persistence/app_database.dart';

Future<void> validateSavingsParent(AppDatabase db, SavingsEntry entry) async {
  final customer =
      await (db.select(db.customerRecords)
            ..where((r) => r.id.equals(entry.customerId) & r.ownerId.equals(entry.ownerId)))
          .getSingleOrNull();
  if (customer == null) throw StateError('Customer not found in account');
  if (entry.orderId == null) return;
  final order =
      await (db.select(db.orderRecords)..where(
            (r) =>
                r.id.equals(entry.orderId!) &
                r.ownerId.equals(entry.ownerId) &
                r.customerId.equals(entry.customerId),
          ))
          .getSingleOrNull();
  if (order == null) throw StateError('Order does not belong to customer');
}
