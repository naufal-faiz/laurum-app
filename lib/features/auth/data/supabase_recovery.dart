import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/data/auth_error_mapping.dart';
import 'package:laurum/features/auth/data/auth_gateway.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Recovery links open a valid session that must set a new password first.
/// The flag lives in the service so the router sees it through [AuthService].
mixin SupabaseRecovery implements AuthService {
  AuthGateway get gateway;
  bool _recovering = false;

  void watchRecovery({bool active = false}) {
    _recovering = active;
    gateway.recoveryEvents.listen((_) => _recovering = true);
  }

  @override
  bool get recovering => _recovering && gateway.currentUser != null;

  /// No old password is asked: the recovery session already proves ownership.
  @override
  Future<void> setRecoveredPassword(String password) async {
    if (gateway.currentUser == null) throw const AuthFailure(AuthFailureKind.unavailable);
    try {
      await gateway.changePassword(password);
    } on AuthException catch (error) {
      throw failureFor(error);
    }
    _recovering = false;
  }

  void clearRecovery() => _recovering = false;
}
