import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Minimal key/value surface so session storage can be tested without plugins.
abstract interface class TokenStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class FlutterSecureTokenStore implements TokenStore {
  const FlutterSecureTokenStore([this._storage = const FlutterSecureStorage()]);
  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
