import 'package:laurum/core/domain/repositories/local_settings_repository.dart';

const syncLastAtKey = 'sync_last_at';

/// Persists the last successful cycle as a device preference (AGENTS rule 20).
/// An empty value means the account never synced on this device.
class SyncLastAtStore {
  SyncLastAtStore(this.settings);
  final LocalSettingsRepository settings;

  Future<DateTime?> read() async {
    final value = await settings.getString(syncLastAtKey);
    return value == null || value.isEmpty ? null : DateTime.tryParse(value);
  }

  Future<void> write(DateTime value) => settings.setString(syncLastAtKey, value.toIso8601String());

  Future<void> clear() => settings.setString(syncLastAtKey, '');
}
