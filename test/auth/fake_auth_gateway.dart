import 'package:laurum/features/auth/data/auth_gateway.dart';
import 'package:laurum/features/auth/data/auth_identity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

AuthIdentity identity({
  String id = 'owner-1',
  String email = 'ratna@example.com',
  String name = 'Bu Ratna',
  String phone = '',
  bool confirmed = true,
  bool password = true,
  bool google = false,
}) => AuthIdentity(
  id: id,
  email: email,
  name: name,
  phone: phone,
  emailConfirmed: confirmed,
  usesPassword: password,
  googleLinked: google,
);

class FakeAuthGateway implements AuthGateway {
  FakeAuthGateway({this.user});
  AuthIdentity? user;
  AuthException? signInError, signUpError, googleError, profileError, passwordError, resetError;
  AuthException? verifyError, updatePasswordError;
  final calls = <String>[];
  String? lastReset, lastGoogleToken;

  @override
  AuthIdentity? get currentUser => user;

  @override
  Future<AuthIdentity> signInWithPassword(String email, String password) async {
    calls.add('signIn:$email');
    final verify = verifyError;
    if (verify != null) {
      verifyError = null;
      throw verify;
    }
    if (signInError != null) throw signInError!;
    return user = identity(email: email.trim().toLowerCase());
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    calls.add('signUp:$email');
    if (signUpError != null) throw signUpError!;
  }

  @override
  Future<AuthIdentity> signInWithGoogleIdToken(String idToken) async {
    calls.add('google');
    lastGoogleToken = idToken;
    if (googleError != null) throw googleError!;
    return user = identity(google: true, password: false);
  }

  @override
  Future<AuthIdentity> updateProfile({required String name, required String phone}) async {
    calls.add('profile');
    if (profileError != null) throw profileError!;
    return user = identity(name: name, phone: phone);
  }

  @override
  Future<AuthIdentity> changePassword(String password) async {
    calls.add('changePassword');
    if (updatePasswordError != null) throw updatePasswordError!;
    return user ??= identity();
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    calls.add('reset:$email');
    lastReset = email;
    if (resetError != null) throw resetError!;
  }

  @override
  Future<void> signOut() async {
    calls.add('signOut');
    user = null;
  }
}

class FakeGoogleTokenSource implements GoogleTokenSource {
  FakeGoogleTokenSource([this.token]);
  String? token;
  Exception? error;
  int calls = 0;

  @override
  Future<String?> idToken() async {
    calls++;
    if (error != null) throw error!;
    return token;
  }
}
