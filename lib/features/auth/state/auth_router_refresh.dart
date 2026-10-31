import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/auth/state/auth_session.dart';

// GoRouter Listenable adapter; session state stays in the Riverpod Notifier.
final authRouterRefreshProvider = Provider<ValueNotifier<int>>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(authSessionProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);
  return refresh;
});
