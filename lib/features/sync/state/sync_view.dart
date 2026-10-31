import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

class SyncView {
  const SyncView(this.status, this.pending, this.lastSyncedAt);
  final SyncServiceStatus status;
  final int pending;
  final DateTime? lastSyncedAt;
  String get label => switch (status) {
    SyncServiceStatus.tersimpan => 'Tersimpan',
    SyncServiceStatus.menyimpan => 'Menyimpan',
    SyncServiceStatus.offline => 'Offline',
    SyncServiceStatus.gagal => 'Gagal sinkron',
  };
}

final syncViewProvider = Provider<SyncView>((ref) {
  final service = ref.watch(syncServiceProvider);
  final status = ref.watch(shellSyncProvider);
  return SyncView(
    status.hasError ? SyncServiceStatus.gagal : status.value ?? service.currentStatus,
    service.pendingChanges,
    service.lastSyncedAt,
  );
});

class SyncActions extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);
  Future<void> syncNow() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      await ref.read(syncServiceProvider).syncNow();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
    ref.invalidate(syncViewProvider);
  }
}

final syncActionsProvider = NotifierProvider<SyncActions, AsyncValue<void>>(SyncActions.new);
