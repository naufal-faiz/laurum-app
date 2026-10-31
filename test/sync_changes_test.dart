import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/sync/state/sync_view.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  test('local repository writes update pending count and manual sync drains it', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final repo = scope.read(businessRepositoryProvider);
    final profile = await repo.getProfile();
    await repo.saveProfile(profile.withOrderStatus(enabled: false));
    final sync = scope.read(syncServiceProvider);
    expect(sync.pendingChanges, 1);
    expect(sync.currentStatus, SyncServiceStatus.menyimpan);
    await repo.saveProfile(profile);
    expect(scope.read(syncViewProvider).pending, 2);
    await scope.read(syncActionsProvider.notifier).syncNow();
    expect(sync.pendingChanges, 0);
    expect(sync.currentStatus, SyncServiceStatus.tersimpan);
  });
}
