import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/auth/state/account_identity.dart';
import 'package:laurum/features/auth/state/auth_error.dart';
import 'package:laurum/features/auth/state/auth_state.dart';
export 'package:laurum/features/auth/state/auth_state.dart';

final authSessionProvider = NotifierProvider<AuthSession, AuthState>(AuthSession.new);

class AuthSession extends Notifier<AuthState> {
  @override
  AuthState build() {
    final auth = ref.watch(authServiceProvider);
    // A deep link or an external confirmation changes the session without a
    // local call; mirror it so the router and storage gate see it.
    final changes = auth.sessionChanges.listen((_) {
      ref.read(accountIdentityProvider.notifier).refresh();
      state = authSnapshot(auth, busy: state.busy);
    });
    ref.onDispose(changes.cancel);
    return authSnapshot(auth);
  }

  AuthState _snapshot({bool busy = false, String? error}) =>
      authSnapshot(ref.read(authServiceProvider), busy: busy, error: error);
  Future<void> _restore() async {
    try {
      await ref.read(syncServiceProvider).syncNow();
    } catch (_) {
      /* Local data remains usable when restoration fails. */
    }
  }

  Future<bool> _login(Future<bool> Function(AuthService) action, String failure) => _run(() async {
    final auth = ref.read(authServiceProvider);
    if (!await action(auth)) return false;
    ref.read(accountIdentityProvider.notifier).refresh();
    state = _snapshot(busy: true);
    if (!auth.needsBusinessSetup) await _restore();
    return true;
  }, failure: failure);
  Future<bool> signIn() =>
      _login((auth) => auth.signInWithGoogle(), 'Masuk dibatalkan. Coba lagi.');
  Future<bool> signInWithPassword(String email, String password) => _login(
    (auth) => auth.signInWithPassword(email, password),
    'Email atau password tidak cocok.',
  );
  Future<bool> signUp(String email, String password, String name) => _run(() async {
    await ref.read(authServiceProvider).signUp(email, password, name);
    return true;
  });
  Future<bool> confirmEmail() => _run(
    () => ref.read(authServiceProvider).confirmEmail(),
    failure: 'Tautan tidak dapat diproses. Periksa email atau masuk kembali.',
  );
  Future<bool> updateProfile(String name, String phone) => _run(() async {
    await ref.read(authServiceProvider).updateProfile(name, phone);
    return true;
  });
  Future<bool> changePassword(String current, String next) => _run(() async {
    await ref.read(authServiceProvider).changePassword(current, next);
    return true;
  });
  Future<bool> completeSetup() => _run(() async {
    await ref.read(authServiceProvider).completeBusinessSetup();
    await _restore();
    return true;
  });
  Future<bool> signOut() => _run(() async {
    await ref.read(authServiceProvider).signOut();
    return true;
  });
  Future<bool> deleteAccount() => _run(() async {
    final local = ref.read(localDataServiceProvider);
    final deleted = await ref.read(transactionRunnerProvider).run(() async {
      if (ref.read(syncServiceProvider).currentStatus == SyncServiceStatus.offline) {
        throw StateError('Account deletion requires connectivity');
      }
      if (!await ref.read(authServiceProvider).deleteAccount()) return false;
      await local.deleteLocalData();
      return true;
    });
    if (deleted) await local.finishDelete();
    return deleted;
  });
  Future<bool> _run(Future<bool> Function() action, {String? failure}) async {
    if (state.busy) return false;
    state = _snapshot(busy: true);
    try {
      final ok = await action();
      ref.read(accountIdentityProvider.notifier).refresh();
      state = _snapshot(error: ok ? null : failure ?? 'Tindakan gagal. Data lokal dipertahankan.');
      return ok;
    } catch (error) {
      ref.read(accountIdentityProvider.notifier).refresh();
      state = _snapshot(error: authErrorMessage(error));
      return false;
    }
  }
}
