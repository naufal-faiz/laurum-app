import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/transaction_runner.dart';
import 'package:laurum/features/auth/data/auth_error_mapping.dart';
import 'package:laurum/features/auth/data/auth_gateway.dart';
import 'package:laurum/features/auth/data/auth_identity.dart';
import 'package:laurum/features/auth/data/supabase_account_actions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Real Auth implementation backed by Supabase. Passwords and tokens never
/// leave the gateway; this class only exposes session identity.
class SupabaseAuthService
    with SupabaseAccountActions
    implements AuthService, TransactionParticipant {
  SupabaseAuthService(this._gateway, this._google);
  final AuthGateway _gateway;
  final GoogleTokenSource _google;
  bool _needsSetup = true, _awaitingEmail = false;
  AuthIdentity? get _user => _gateway.currentUser;
  @override
  AuthGateway get gateway => _gateway;
  @override
  bool get isSignedIn => _user != null;
  @override
  String? get currentUserId => _user?.id;
  @override
  String get email => _user?.email ?? '';
  @override
  String get name => _user?.name ?? '';
  @override
  String get phone => _user?.phone ?? '';
  @override
  bool get usesPassword => _user?.usesPassword ?? false;
  @override
  bool get googleLinked => _user?.googleLinked ?? false;
  @override
  bool get awaitingEmail => _awaitingEmail && !isSignedIn;
  @override
  bool get needsBusinessSetup => isSignedIn && _needsSetup;
  @override
  Future<void> completeBusinessSetup() async => _needsSetup = false;
  @override
  Future<bool> signInWithPassword(String email, String password) =>
      _login(() => _gateway.signInWithPassword(email, password));
  @override
  Future<bool> signInWithGoogle() async => _login(() async {
    final token = await _google.idToken();
    return token == null ? null : await _gateway.signInWithGoogleIdToken(token);
  });
  @override
  Future<void> signUp(String email, String password, String name) async {
    try {
      await _gateway.signUp(email: email, password: password, name: name);
    } on AuthException catch (error) {
      final kind = classifyAuthError(error);
      if (kind != null) throw AuthFailure(kind);
      /* Duplicate e-mail stays indistinguishable from a fresh registration. */
    }
    _awaitingEmail = true;
  }

  @override
  Future<bool> confirmEmail() async {
    if (!isSignedIn || !await confirmedSession()) return false;
    _awaitingEmail = false;
    _needsSetup = true;
    return true;
  }

  @override
  Future<void> signOut() async {
    try {
      await _gateway.signOut();
    } finally {
      _awaitingEmail = false;
      _needsSetup = true;
    }
  }

  @override
  Future<bool> deleteAccount() async {
    final deleted = await super.deleteAccount();
    _awaitingEmail = false;
    _needsSetup = true;
    return deleted;
  }

  @override
  void Function() checkpoint() => () {};

  /// Wrong credentials return false; other failures surface as safe kinds.
  Future<bool> _login(Future<AuthIdentity?> Function() action) async {
    try {
      final user = await action();
      if (user == null) return false;
      _awaitingEmail = false;
      _needsSetup = true;
      return user.id.isNotEmpty;
    } on AuthException catch (error) {
      final kind = classifyAuthError(error);
      if (kind == null) return false;
      throw AuthFailure(kind);
    }
  }
}
