import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/features/auth/data/auth_error_mapping.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('rate limits and invalid input map to their own kinds', () {
    expect(
      classifyAuthError(const AuthException('x', statusCode: '429')),
      AuthFailureKind.requestLimit,
    );
    expect(
      classifyAuthError(const AuthException('x', code: 'over_email_send_rate_limit')),
      AuthFailureKind.requestLimit,
    );
    expect(
      classifyAuthError(const AuthException('x', statusCode: '422', code: 'weak_password')),
      AuthFailureKind.invalidInput,
    );
  });

  test('credential failures stay silent; network and unknown stay generic', () {
    expect(
      classifyAuthError(const AuthException('x', statusCode: '400', code: 'invalid_credentials')),
      isNull,
    );
    expect(
      classifyAuthError(const AuthException('x', statusCode: '422', code: 'user_already_exists')),
      isNull,
    );
    expect(classifyAuthError(AuthRetryableFetchException()), AuthFailureKind.unavailable);
    expect(classifyAuthError(const AuthException('x')), AuthFailureKind.unavailable);
  });

  test('password verification maps wrong credentials to the current-password kind', () {
    final failure = failureForCredentials(
      const AuthException('x', statusCode: '400', code: 'invalid_credentials'),
      AuthFailureKind.currentPassword,
    );
    expect(failure.kind, AuthFailureKind.currentPassword);
    expect(
      failureFor(const AuthException('x', statusCode: '429')).kind,
      AuthFailureKind.requestLimit,
    );
  });
}
