import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';

typedef AuthState = ({bool signedIn, bool needsSetup, bool busy, String? error});
final authSessionProvider = NotifierProvider<AuthSession, AuthState>(AuthSession.new);

class AuthSession extends Notifier<AuthState> {
  @override
  AuthState build() {
    ref.watch(authServiceProvider);
    return _snapshot();
  }

  AuthState _snapshot({bool busy = false, String? error}) {
    final auth = ref.read(authServiceProvider);
    return (
      signedIn: auth.isSignedIn,
      needsSetup: auth.needsBusinessSetup,
      busy: busy,
      error: error,
    );
  }

  Future<void> _restore() async {
    try {
      await ref.read(syncServiceProvider).syncNow();
    } catch (_) {
      /* Login remains available with local data when sync fails. */
    }
  }

  Future<bool> signIn() async {
    if (state.busy) return false;
    state = _snapshot(busy: true);
    try {
      final auth = ref.read(authServiceProvider);
      if (!await auth.signInWithGoogle()) {
        state = _snapshot(error: 'Masuk dibatalkan. Coba lagi.');
        return false;
      }
      state = _snapshot(busy: true);
      if (!auth.needsBusinessSetup) await _restore();
      state = _snapshot();
      return true;
    } catch (_) {
      state = _snapshot(error: 'Gagal masuk. Coba lagi.');
      return false;
    }
  }

  Future<bool> completeSetup() => _run(() async {
    await ref.read(authServiceProvider).completeBusinessSetup();
    await _restore();
    return true;
  });
  Future<bool> signOut() => _run(() async {
    await ref.read(authServiceProvider).signOut();
    return true;
  });
  Future<bool> deleteAccount() => _run(
    () => ref.read(transactionRunnerProvider).run(() async {
      if (ref.read(syncServiceProvider).currentStatus == SyncServiceStatus.offline) {
        throw StateError('Account deletion requires connectivity');
      }
      if (!await ref.read(authServiceProvider).deleteAccount()) return false;
      await ref.read(localDataServiceProvider).deleteLocalData();
      return true;
    }),
  );
  Future<bool> _run(Future<bool> Function() action) async {
    if (state.busy) return false;
    state = _snapshot(busy: true);
    try {
      final ok = await action();
      state = _snapshot(error: ok ? null : 'Tindakan gagal. Data lokal dipertahankan.');
      return ok;
    } catch (_) {
      state = _snapshot(error: 'Tindakan gagal. Periksa koneksi dan coba lagi.');
      return false;
    }
  }
}
