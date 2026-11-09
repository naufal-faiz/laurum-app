import 'package:laurum/core/services/auth_config.dart';
import 'package:laurum/features/auth/data/auth_gateway.dart';
import 'package:laurum/features/auth/data/auth_identity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthGateway implements AuthGateway {
  SupabaseAuthGateway(this._client);
  final SupabaseClient _client;
  GoTrueClient get _auth => _client.auth;

  @override
  AuthIdentity? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : authUserFromSupabase(user);
  }

  @override
  Future<AuthIdentity> signInWithPassword(String email, String password) async {
    final response = await _auth.signInWithPassword(
      email: normalizeAuthEmail(email),
      password: password,
    );
    return _requireUser(response.user);
  }

  @override
  Future<void> signUp({required String email, required String password, required String name}) =>
      _auth.signUp(
        email: normalizeAuthEmail(email),
        password: password,
        data: {'name': name.trim()},
        emailRedirectTo: authCallbackUri,
      );

  @override
  Future<AuthIdentity> signInWithGoogleIdToken(String idToken) async {
    final response = await _auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
    return _requireUser(response.user);
  }

  @override
  Future<AuthIdentity> updateProfile({required String name, required String phone}) async {
    final response = await _auth.updateUser(
      UserAttributes(data: {'name': name.trim(), 'phone': phone.trim()}),
    );
    return _requireUser(response.user);
  }

  @override
  Future<AuthIdentity> changePassword(String password) async {
    final response = await _auth.updateUser(UserAttributes(password: password));
    return _requireUser(response.user);
  }

  @override
  Future<void> sendPasswordReset(String email) =>
      _auth.resetPasswordForEmail(normalizeAuthEmail(email), redirectTo: authCallbackUri);

  @override
  Future<void> signOut() => _auth.signOut();
}

String normalizeAuthEmail(String email) => email.trim().toLowerCase();

AuthIdentity _requireUser(User? user) {
  if (user == null) throw const AuthException('missing user');
  return authUserFromSupabase(user);
}

AuthIdentity authUserFromSupabase(User user) {
  final metadata = user.userMetadata ?? const <String, dynamic>{};
  final providers = (user.identities ?? const <UserIdentity>[])
      .map((identity) => identity.provider)
      .toSet();
  return AuthIdentity(
    id: user.id,
    email: user.email ?? '',
    name: _text(metadata['name']),
    phone: _text(metadata['phone']),
    emailConfirmed: user.emailConfirmedAt != null,
    usesPassword: providers.contains('email'),
    googleLinked: providers.contains('google'),
  );
}

String _text(Object? value) => value is String ? value : '';
