import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/auth/state/auth_session.dart';

/// A later successful pull can finish restoration after an offline startup.
final accountSetupRestoreProvider = FutureProvider<void>((ref) async {
  final store = await ref.watch(accountStoreProvider.future);
  if (!ref.mounted || store == null) return;
  ref.watch(accountChangesProvider);
  final auth = ref.read(authServiceProvider);
  if (!auth.needsBusinessSetup) return;
  final profile = await store.business.getProfile();
  if (!ref.mounted || auth.currentUserId != store.ownerId || profile.name.isEmpty) return;
  await auth.completeBusinessSetup();
  if (ref.mounted) ref.invalidate(authSessionProvider);
});
