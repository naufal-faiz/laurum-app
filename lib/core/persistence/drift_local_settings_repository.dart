import 'package:drift/drift.dart';
import 'package:laurum/core/domain/repositories/local_settings_repository.dart';
import 'package:laurum/core/persistence/app_database.dart';

class DriftLocalSettingsRepository implements LocalSettingsRepository {
  DriftLocalSettingsRepository(this.db);
  final AppDatabase db;
  Future<LocalSettingRow?> _read(String key) =>
      (db.select(db.localSettingRecords)..where((r) => r.key.equals(key))).getSingleOrNull();
  @override
  Future<String?> getString(String key) async => (await _read(key))?.stringValue;
  @override
  Future<int?> getInt(String key) async => (await _read(key))?.intValue;
  @override
  Future<void> setString(String key, String value) async {
    await db
        .into(db.localSettingRecords)
        .insertOnConflictUpdate(
          LocalSettingRecordsCompanion(
            key: Value(key),
            stringValue: Value(value),
            intValue: const Value(null),
          ),
        );
  }

  @override
  Future<void> setInt(String key, int value) async {
    await db
        .into(db.localSettingRecords)
        .insertOnConflictUpdate(
          LocalSettingRecordsCompanion(
            key: Value(key),
            stringValue: const Value(null),
            intValue: Value(value),
          ),
        );
  }
}
