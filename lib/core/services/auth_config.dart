/// Public Supabase/Auth configuration. Secrets never live here: the publishable
/// key is safe in the app because RLS guards every row.
class AuthConfig {
  const AuthConfig({
    required this.supabaseUrl,
    required this.publishableKey,
    required this.googleWebClientId,
  });
  final String supabaseUrl;
  final String publishableKey;
  final String googleWebClientId;

  bool get canUseSupabase =>
      publishableKey.isNotEmpty && _validUrl(supabaseUrl) && supabaseUrl.trim() == supabaseUrl;
  bool get canUseGoogle => canUseSupabase && googleWebClientId.isNotEmpty;

  static bool _validUrl(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri == null || uri.host.isEmpty) return false;
    final local = uri.host == 'localhost' || uri.host == '127.0.0.1';
    return uri.scheme == 'https' || (uri.scheme == 'http' && local);
  }
}

/// Passed with `--dart-define` or `--dart-define-from-file=.env.local`.
const authConfigFromEnvironment = AuthConfig(
  supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
  publishableKey: String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
  googleWebClientId: String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
);

/// Must match the Supabase Auth `site_url`/redirect allow list and the Android
/// intent filter in `android/app/src/main/AndroidManifest.xml`.
const authCallbackUri = 'laurum://auth-callback';

/// Only this scheme/host carries an Auth callback; other links are ignored.
bool isAuthCallbackUri(Uri uri) {
  if (uri.scheme != 'laurum' || uri.host != 'auth-callback') return false;
  const keys = {'code', 'access_token', 'error', 'error_code', 'error_description'};
  final fragment = uri.hasFragment ? Uri.splitQueryString(uri.fragment) : const <String, String>{};
  return keys.any(uri.queryParameters.containsKey) || keys.any(fragment.containsKey);
}

/// A recovery callback must set a new password before the app opens.
bool isRecoveryUri(Uri uri) {
  if (!isAuthCallbackUri(uri)) return false;
  final fragment = uri.hasFragment ? Uri.splitQueryString(uri.fragment) : const <String, String>{};
  return uri.queryParameters['type'] == 'recovery' || fragment['type'] == 'recovery';
}
