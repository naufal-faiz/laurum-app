import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/persistence/storage_providers.dart';

final storageRecoveryProvider = NotifierProvider<StorageRecovery, bool>(StorageRecovery.new);

class StorageRecovery extends Notifier<bool> {
  @override
  bool build() => false;
  Future<void> retry() async {
    if (state) return;
    state = true;
    try {
      await ref.read(accountStorageProvider).close();
      if (!ref.mounted) return;
      ref.invalidate(accountStoreProvider);
      await ref.read(accountStoreProvider.future);
    } catch (_) {
      // The storage gate keeps a recoverable error; no local files are removed.
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
