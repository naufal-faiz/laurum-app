import 'package:laurum/features/auth/data/auth_identity.dart';

/// Narrow wrapper around the Supabase Auth API so the service can be tested
/// without a network or plugin. Implementations may throw `AuthException`.
abstract interface class AuthGateway {
  AuthIdentity? get currentUser;
  Future<AuthIdentity> signInWithPassword(String email, String password);
  Future<void> signUp({required String email, required String password, required String name});
  Future<AuthIdentity> signInWithGoogleIdToken(String idToken);
  Future<AuthIdentity> updateProfile({required String name, required String phone});
  Future<AuthIdentity> changePassword(String password);
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
}

/// Supplies a Google ID token from the native account picker. Returns null when
/// the user cancels.
abstract interface class GoogleTokenSource {
  Future<String?> idToken();
}
