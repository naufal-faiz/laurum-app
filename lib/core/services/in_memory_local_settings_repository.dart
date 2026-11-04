import 'package:laurum/core/domain/repositories/local_settings_repository.dart';
import 'package:laurum/core/services/transaction_runner.dart';

class InMemoryLocalSettingsRepository implements LocalSettingsRepository, TransactionParticipant {
  Map<String, Object> _values = {};
  @override
  Future<String?> getString(String key) async => switch (_values[key]) {
    final String value => value,
    _ => null,
  };
  @override
  Future<int?> getInt(String key) async => switch (_values[key]) {
    final int value => value,
    _ => null,
  };
  @override
  Future<void> setString(String key, String value) async => _values[key] = value;
  @override
  Future<void> setInt(String key, int value) async => _values[key] = value;
  void clearLocalData() => _values = {};
  @override
  void Function() checkpoint() {
    final saved = Map<String, Object>.of(_values);
    return () => _values = Map.of(saved);
  }
}
