import 'package:laurum/core/persistence/token_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Persists the Supabase session in the platform keystore (aturan 20) instead
/// of SharedPreferences.
class SecureSessionStorage extends LocalStorage {
  SecureSessionStorage({TokenStore? store}) : _store = store ?? const FlutterSecureTokenStore();
  final TokenStore _store;
  static const sessionKey = 'laurum.supabase.session';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => await _store.read(sessionKey) != null;

  @override
  Future<String?> accessToken() => _store.read(sessionKey);

  @override
  Future<void> persistSession(String persistSessionString) =>
      _store.write(sessionKey, persistSessionString);

  @override
  Future<void> removePersistedSession() => _store.delete(sessionKey);
}

/// Short-lived PKCE verifiers also stay in the keystore.
class SecurePkceStorage extends GotrueAsyncStorage {
  const SecurePkceStorage([this._store = const FlutterSecureTokenStore()]);
  final TokenStore _store;
  static const _prefix = 'laurum.supabase.pkce.';

  @override
  Future<String?> getItem({required String key}) => _store.read('$_prefix$key');

  @override
  Future<void> setItem({required String key, required String value}) =>
      _store.write('$_prefix$key', value);

  @override
  Future<void> removeItem({required String key}) => _store.delete('$_prefix$key');
}
