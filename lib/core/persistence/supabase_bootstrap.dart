import 'package:laurum/core/persistence/secure_session_storage.dart';
import 'package:laurum/core/services/auth_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

bool _initialized = false;

/// Set when the callback that opened the app carries a recovery token, so the
/// first frame opens "Buat password baru" instead of the home shell.
bool recoveryLinkAtStartup = false;

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
      detectSessionInUriPredicate: (uri) {
        if (isRecoveryUri(uri)) recoveryLinkAtStartup = true;
        return isAuthCallbackUri(uri);
      },
    ),
  );
  _initialized = true;
  return true;
}
