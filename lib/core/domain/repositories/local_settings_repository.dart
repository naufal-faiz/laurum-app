abstract interface class LocalSettingsRepository {
  Future<String?> getString(String key);
  Future<int?> getInt(String key);
  Future<void> setString(String key, String value);
  Future<void> setInt(String key, int value);
}
