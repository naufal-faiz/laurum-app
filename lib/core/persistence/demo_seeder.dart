import 'package:drift/drift.dart';
import 'package:laurum/core/domain/customer_search.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/demo_fixture_id.dart';
import 'package:laurum/core/persistence/demo_seed_payloads.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';

class DemoSeeder {
  DemoSeeder(this.db, this.ownerId, this.writer);
  final AppDatabase db;
  final String ownerId;
  final OutboxWriter writer;
  String id(String fixtureId) => demoFixtureId(ownerId, fixtureId);
  Future<void> run() => writer.runner.run(() async {
    final settings = DriftLocalSettingsRepository(db);
    if (await settings.getInt('demo_seed_v1') == 1) return;
    // Never inject demo transactions into an existing business/account.
    for (final table in db.allTables.where((t) => t.$columns.any((c) => c.$name == 'owner_id'))) {
      if ((await db.customSelect('SELECT 1 FROM ${table.actualTableName} LIMIT 1').get())
          .isNotEmpty) {
        return;
      }
    }
    for (final group in demoSeedPayloads().entries) {
      for (final original in group.value) {
        final payload = {
          for (final entry in original.entries)
            entry.key: entry.key == 'owner_id'
                ? ownerId
                : (entry.key == 'id' || entry.key.endsWith('_id')) && entry.value != null
                ? id(entry.value! as String)
                : entry.value,
        };
        final local = Map<String, Object?>.of(payload);
        for (final key in ['entered_at', 'paid_at', 'spent_at']) {
          if (local[key] != null) local[key] = sqlTimestamp(DateTime.parse(local[key]! as String));
        }
        if (group.key == 'customers') {
          local['name_key'] = customerNameKey(local['name']! as String);
          local['phone_key'] = customerPhoneKey(local['phone']! as String);
        }
        if (group.key == 'savings_entries') {
          local['created_key'] = sqlTimestamp(DateTime.parse(local['created_at']! as String));
        }
        final table = db.allTables.singleWhere((t) => t.actualTableName == group.key);
        await writer.write(
          table: group.key,
          rowId: payload['id']! as String,
          payload: payload,
          mutate: () => db.customInsert(
            'INSERT INTO ${group.key} (${local.keys.join(',')}) '
            'VALUES (${List.filled(local.length, '?').join(',')})',
            variables: [for (final v in local.values) Variable(v is bool ? (v ? 1 : 0) : v)],
            updates: {table},
          ),
        );
      }
    }
    await settings.setInt('demo_seed_v1', 1);
  });
}
