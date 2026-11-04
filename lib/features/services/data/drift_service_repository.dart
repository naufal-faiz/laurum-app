import 'package:drift/drift.dart';
import 'package:laurum/core/domain/repositories/service_repository.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/services/data/service_storage_mapping.dart';

class DriftServiceRepository implements ServiceRepository {
  DriftServiceRepository(this.db, this.ownerId, this.writer, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now {
    if (!identical(db, writer.db)) throw ArgumentError('Outbox belongs to another database');
  }
  final AppDatabase db;
  final String ownerId;
  final OutboxWriter writer;
  final DateTime Function() clock;
  @override
  Future<List<ServiceItem>> getServices({bool includeInactive = false}) async {
    final query = db.select(db.serviceRecords)
      ..where(
        (r) =>
            r.ownerId.equals(ownerId) &
            r.deletedAt.isNull() &
            (includeInactive ? const Constant(true) : r.isActive.equals(true)),
      )
      ..orderBy([(r) => OrderingTerm.asc(r.sortOrder), (r) => OrderingTerm.asc(r.rowId)]);
    return List.unmodifiable((await query.get()).map(serviceFromRow));
  }

  @override
  Future<ServiceItem?> getServiceById(String id) async {
    final row =
        await (db.select(db.serviceRecords)..where(
              (r) => r.id.equals(id) & r.ownerId.equals(ownerId) & r.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    return row == null ? null : serviceFromRow(row);
  }

  @override
  Future<void> saveService(ServiceItem service) => writer.runner.run(() async {
    if (service.ownerId != ownerId) throw StateError('Service belongs to another account');
    final table = db.serviceRecords;
    final old = await (db.select(table)..where((r) => r.id.equals(service.id))).getSingleOrNull();
    if (old != null && old.ownerId != ownerId) {
      throw StateError('Service belongs to another account');
    }
    final at = clock();
    await writer.write(
      table: 'services',
      rowId: service.id,
      payload: servicePayload(service, at),
      mutate: () async {
        await db.into(table).insertOnConflictUpdate(serviceToRow(service, at));
      },
    );
  });
  @override
  Future<void> deleteService(String id) => writer.runner.run(() async {
    final service = await getServiceById(id);
    if (service != null) await saveService(deletedService(service, clock()));
  });
}
