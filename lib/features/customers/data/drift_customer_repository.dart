import 'package:drift/drift.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/customer_search.dart';
import 'package:laurum/core/domain/repositories/customer_repository.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/customers/data/customer_queries.dart';
import 'package:laurum/features/customers/data/customer_storage_mapping.dart';
import 'package:sqlite3/sqlite3.dart';

class DriftCustomerRepository implements CustomerRepository {
  DriftCustomerRepository(this.db, this.ownerId, this.writer, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now {
    if (!identical(db, writer.db)) throw ArgumentError('Outbox belongs to another database');
  }
  final AppDatabase db;
  final String ownerId;
  final OutboxWriter writer;
  final DateTime Function() clock;
  @override
  Future<List<Customer>> getCustomers({bool includeInactive = false, String query = ''}) async =>
      List.unmodifiable(
        (await readCustomers(
          db,
          ownerId,
          includeInactive: includeInactive,
          query: query,
        )).map(customerFromRow),
      );
  @override
  Future<Customer?> getCustomerById(String id) async {
    final row =
        await (db.select(db.customerRecords)
              ..where((r) => r.id.equals(id) & r.ownerId.equals(ownerId) & r.deletedAt.isNull()))
            .getSingleOrNull();
    return row == null ? null : customerFromRow(row);
  }

  @override
  Future<void> saveCustomer(Customer c) => writer.runner.run(() async {
    if (c.ownerId != ownerId) throw StateError('Customer belongs to another account');
    final t = db.customerRecords;
    final old = await (db.select(t)..where((r) => r.id.equals(c.id))).getSingleOrNull();
    if (old != null && old.ownerId != ownerId) {
      throw StateError('Customer belongs to another account');
    }
    final key = customerPhoneKey(c.phone);
    if (key.isNotEmpty && c.isActive && c.deletedAt == null) {
      final duplicate =
          await (db.select(t)..where(
                (r) =>
                    r.ownerId.equals(ownerId) &
                    r.phoneKey.equals(key) &
                    r.isActive.equals(true) &
                    r.deletedAt.isNull() &
                    r.id.equals(c.id).not(),
              ))
              .getSingleOrNull();
      if (duplicate != null) throw StateError('Active customer phone must be unique');
    }
    final at = clock();
    try {
      await writer.write(
        table: 'customers',
        rowId: c.id,
        payload: customerPayload(c, at),
        mutate: () async {
          await db.into(t).insertOnConflictUpdate(customerToRow(c, at));
        },
      );
    } on SqliteException catch (e) {
      // SQLITE_CONSTRAINT_UNIQUE from the normalized active-phone index.
      if (e.extendedResultCode == 2067 && e.message.contains('phone_key')) {
        throw StateError('Active customer phone must be unique');
      }
      rethrow;
    }
  });
  @override
  Future<void> deleteCustomer(String id) => writer.runner.run(() async {
    final customer = await getCustomerById(id);
    if (customer != null) await saveCustomer(deletedCustomer(customer, clock()));
  });
}
