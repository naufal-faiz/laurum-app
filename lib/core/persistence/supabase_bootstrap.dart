import 'package:laurum/core/persistence/secure_session_storage.dart';
import 'package:laurum/core/services/auth_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

bool _initialized = false;

/// Initializes Supabase once, restores the keystore session before the first
/// frame, and listens for the `laurum://auth-callback` deep link.
/// Returns false when the build has no public configuration: the app keeps
/// running in dummy mode without touching the network.
Future<bool> initializeSupabase(AuthConfig config) async {
  if (!config.canUseSupabase) return false;
  if (_initialized) return true;
  await Supabase.initialize(
    url: config.supabaseUrl,
    publishableKey: config.publishableKey,
    authOptions: FlutterAuthClientOptions(
      localStorage: SecureSessionStorage(),
      pkceAsyncStorage: const SecurePkceStorage(),
      detectSessionInUriPredicate: isAuthCallbackUri,
    ),
  );
  _initialized = true;
  return true;
}
