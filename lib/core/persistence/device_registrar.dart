import 'dart:io';

import 'package:drift/drift.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';

/// Records this install once per account so `devices` syncs like any other row.
/// The identity is a stable UUID kept in `local_settings` (device state, aturan
/// 20); `device_code` stays free for the order-number prefix.
class DeviceRegistrar {
  DeviceRegistrar(
    this.db,
    this.ownerId,
    this.writer, {
    this.ids = const IdGenerator(),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;
  final AppDatabase db;
  final String ownerId;
  final OutboxWriter writer;
  final IdGenerator ids;
  final DateTime Function() clock;
  static const codeKey = 'device_identity';

  Future<String> code() async {
    final settings = DriftLocalSettingsRepository(db);
    final stored = await settings.getString(codeKey);
    if (stored != null && stored.isNotEmpty) return stored;
    final created = ids.newId();
    await settings.setString(codeKey, created);
    return created;
  }

  Future<void> ensureRegistered() async {
    final deviceCode = await code();
    final existing = await (db.select(
      db.deviceRecords,
    )..where((r) => r.ownerId.equals(ownerId) & r.code.equals(deviceCode))).getSingleOrNull();
    if (existing != null) return;
    final id = ids.newId();
    final at = clock().toUtc();
    final name = _deviceName;
    await writer.write(
      table: 'devices',
      rowId: id,
      payload: {
        'id': id,
        'owner_id': ownerId,
        'created_at': at.toIso8601String(),
        'updated_at': at.toIso8601String(),
        'deleted_at': null,
        'code': deviceCode,
        'name': name,
        'last_seen_at': at.toIso8601String(),
      },
      mutate: () => db
          .into(db.deviceRecords)
          .insert(
            DeviceRecordsCompanion.insert(
              id: id,
              ownerId: ownerId,
              createdAt: at,
              updatedAt: Value(at),
              code: deviceCode,
              name: name,
              lastSeenAt: Value(at),
            ),
          ),
    );
  }

  String get _deviceName =>
      Platform.isAndroid ? 'Android' : (Platform.isIOS ? 'iOS' : Platform.operatingSystem);
}
