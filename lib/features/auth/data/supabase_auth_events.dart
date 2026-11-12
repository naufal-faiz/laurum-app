import 'package:laurum/features/auth/data/auth_gateway.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Session broadcasts for the real gateway; kept apart so the gateway file
/// stays inside the line limit.
mixin SupabaseAuthEvents implements AuthGateway {
  GoTrueClient get auth;

  @override
  Stream<void> get sessionChanges => auth.onAuthStateChange.map((_) {});

  @override
  Stream<void> get recoveryEvents => auth.onAuthStateChange
      .where((state) => state.event == AuthChangeEvent.passwordRecovery)
      .map((_) {});
}
