import 'package:laurum/core/services/auth_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Returns null when the credentials are wrong (the caller shows one generic
/// message); otherwise the safe failure kind for the UI.
AuthFailureKind? classifyAuthError(AuthException error) {
  final code = error.code ?? '';
  final status = error.statusCode;
  if (status == '429' || code.contains('rate_limit')) return AuthFailureKind.requestLimit;
  if (code == 'invalid_credentials' ||
      code == 'email_not_confirmed' ||
      code == 'user_not_found' ||
      code == 'user_already_exists') {
    return null;
  }
  if (status == '400' || status == '422' || status == '403') return AuthFailureKind.invalidInput;
  return AuthFailureKind.unavailable;
}

/// Map used by flows where wrong credentials are an error (password change).
AuthFailure failureForCredentials(AuthException error, AuthFailureKind wrong) =>
    AuthFailure(classifyAuthError(error) ?? wrong);

AuthFailure failureFor(AuthException error) =>
    AuthFailure(classifyAuthError(error) ?? AuthFailureKind.unavailable);
