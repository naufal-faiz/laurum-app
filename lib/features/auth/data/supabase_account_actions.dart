import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/data/auth_error_mapping.dart';
import 'package:laurum/features/auth/data/auth_gateway.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Profile, password and reset flows; shares the session gateway with
/// [SupabaseAuthService].
mixin SupabaseAccountActions implements AuthService {
  AuthGateway get gateway;

  @override
  Future<void> updateProfile(String name, String phone) async {
    try {
      await gateway.updateProfile(name: name, phone: phone);
    } on AuthException catch (error) {
      throw failureFor(error);
    }
  }

  @override
  Future<void> changePassword(String current, String next) async {
    final user = gateway.currentUser;
    if (user == null) throw const AuthFailure(AuthFailureKind.unavailable);
    if (!user.usesPassword) throw const AuthFailure(AuthFailureKind.currentPassword);
    try {
      await gateway.signInWithPassword(user.email, current);
    } on AuthException catch (error) {
      throw failureForCredentials(error, AuthFailureKind.currentPassword);
    }
    try {
      await gateway.changePassword(next);
    } on AuthException catch (error) {
      throw failureFor(error);
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await gateway.sendPasswordReset(email);
    } on AuthException catch (error) {
      throw failureFor(error);
    }
  }
}
