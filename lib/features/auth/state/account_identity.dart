import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/service_providers.dart';

// Storage depends on identity, not on AuthSession actions that themselves use storage.
class AccountIdentity extends Notifier<String?> {
  @override
  String? build() => ref.watch(authServiceProvider).currentUserId;
  void refresh() => state = ref.read(authServiceProvider).currentUserId;
}

final accountIdentityProvider = NotifierProvider<AccountIdentity, String?>(AccountIdentity.new);
