import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/secure_session_storage.dart';
import 'package:laurum/core/persistence/token_store.dart';

class MemoryTokenStore implements TokenStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async => values[key] = value;
  @override
  Future<void> delete(String key) async => values.remove(key);
}

void main() {
  test('session persists in the injectable token store, never in preferences', () async {
    final store = MemoryTokenStore();
    final session = SecureSessionStorage(store: store);
    expect(await session.hasAccessToken(), isFalse);
    expect(await session.accessToken(), isNull);
    await session.persistSession('{"refresh_token":"r","access_token":"a"}');
    expect(store.values.keys, [SecureSessionStorage.sessionKey]);
    expect(await session.hasAccessToken(), isTrue);
    expect(await session.accessToken(), contains('access_token'));
    await session.removePersistedSession();
    expect(await session.hasAccessToken(), isFalse);
  });

  test('pkce verifiers use their own prefixed keys', () async {
    final store = MemoryTokenStore();
    final pkce = SecurePkceStorage(store);
    await pkce.setItem(key: 'verifier', value: 'abc/123');
    expect(store.values, {'laurum.supabase.pkce.verifier': 'abc/123'});
    expect(await pkce.getItem(key: 'verifier'), 'abc/123');
    await pkce.removeItem(key: 'verifier');
    expect(store.values, isEmpty);
  });
}
