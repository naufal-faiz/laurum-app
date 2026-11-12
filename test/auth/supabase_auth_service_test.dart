import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/features/auth/data/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'fake_auth_gateway.dart';

AuthException error(String code, {String? status}) =>
    AuthException('not shown', code: code, statusCode: status);

void main() {
  late FakeAuthGateway gateway;
  late FakeGoogleTokenSource google;
  late SupabaseAuthService auth;
  setUp(() {
    gateway = FakeAuthGateway();
    google = FakeGoogleTokenSource('google-id-token');
    auth = SupabaseAuthService(gateway, google);
  });

  test('password login exposes session identity and needs business setup', () async {
    expect(await auth.signInWithPassword(' RATNA@EXAMPLE.COM ', 'Laundry123!'), isTrue);
    expect(gateway.calls, ['signIn: RATNA@EXAMPLE.COM ']);
    expect(auth.isSignedIn, isTrue);
    expect(auth.currentUserId, 'owner-1');
    expect(auth.email, 'ratna@example.com');
    expect(auth.name, 'Bu Ratna');
    expect(auth.usesPassword, isTrue);
    expect(auth.needsBusinessSetup, isTrue);
    await auth.completeBusinessSetup();
    expect(auth.needsBusinessSetup, isFalse);
  });

  test('wrong credentials return false without leaking details; rate limit is safe', () async {
    gateway.signInError = error('invalid_credentials', status: '400');
    expect(await auth.signInWithPassword('ratna@example.com', 'salah'), isFalse);
    expect(auth.isSignedIn, isFalse);
    gateway.signInError = error('over_request_rate_limit', status: '429');
    await expectLater(
      auth.signInWithPassword('ratna@example.com', 'salah'),
      throwsA(isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.requestLimit)),
    );
    gateway.signInError = AuthRetryableFetchException();
    await expectLater(
      auth.signInWithPassword('ratna@example.com', 'salah'),
      throwsA(isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.unavailable)),
    );
  });

  test('registration waits for email; confirming needs a real confirmed session', () async {
    await auth.signUp('baru@example.com', 'NewPass123!', 'Nama Baru');
    expect(auth.isSignedIn, isFalse);
    expect(auth.awaitingEmail, isTrue);
    expect(await auth.confirmEmail(), isFalse);
    gateway.user = identity(name: 'Nama Baru');
    expect(await auth.confirmEmail(), isTrue);
    expect(auth.isSignedIn, isTrue);
    expect(auth.awaitingEmail, isFalse);
    expect(auth.needsBusinessSetup, isTrue);
  });

  test('deep link emits a session change and exposes the signed identity', () async {
    final events = <void>[];
    final subscription = auth.sessionChanges.listen(events.add);
    gateway.deepLink(identity(email: 'baru@example.com'));
    await pumpEventQueue();
    await subscription.cancel();
    expect(events, hasLength(1));
    expect(auth.isSignedIn, isTrue);
    expect(auth.email, 'baru@example.com');
  });

  test('confirming e-mail trusts the server session, not the cached identity', () async {
    gateway.user = identity(confirmed: false);
    gateway.refreshConfirmed = true;
    expect(await auth.confirmEmail(), isTrue);
    expect(auth.needsBusinessSetup, isTrue);
    gateway.user = identity();
    gateway.refreshConfirmed = false;
    expect(await auth.confirmEmail(), isFalse);
    gateway.refreshError = AuthRetryableFetchException();
    expect(await auth.confirmEmail(), isTrue);
    expect(gateway.calls.where((call) => call == 'refreshUser'), hasLength(3));
  });

  test('duplicate registration stays generic; weak password and limits are errors', () async {
    gateway.signUpError = error('user_already_exists', status: '422');
    await auth.signUp('ratna@example.com', 'Attacker123!', 'Lain');
    expect(auth.awaitingEmail, isTrue);
    gateway.signUpError = error('weak_password', status: '422');
    await expectLater(
      auth.signUp('baru@example.com', 'pendek', 'Nama'),
      throwsA(isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.invalidInput)),
    );
    gateway.signUpError = error('over_request_rate_limit', status: '429');
    await expectLater(
      auth.signUp('baru@example.com', 'NewPass123!', 'Nama'),
      throwsA(isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.requestLimit)),
    );
    expect(auth.isSignedIn, isFalse);
  });

  test('google cancel is false, success signs in, unavailable configuration is safe', () async {
    google.token = null;
    expect(await auth.signInWithGoogle(), isFalse);
    expect(gateway.calls, isEmpty);
    google.token = 'google-id-token';
    expect(await auth.signInWithGoogle(), isTrue);
    expect(gateway.lastGoogleToken, 'google-id-token');
    expect(auth.googleLinked, isTrue);
    expect(auth.usesPassword, isFalse);
    google.error = const AuthFailure(AuthFailureKind.unavailable);
    await expectLater(
      auth.signInWithGoogle(),
      throwsA(isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.unavailable)),
    );
  });

  test('profile and password flows use verified current password only', () async {
    await auth.signInWithPassword('ratna@example.com', 'Laundry123!');
    await auth.updateProfile('Ratna Baru', '+6281234567890');
    expect(auth.name, 'Ratna Baru');
    expect(auth.phone, '+6281234567890');
    gateway.calls.clear();
    gateway.verifyError = error('invalid_credentials', status: '400');
    await expectLater(
      auth.changePassword('salah', 'NewPass123!'),
      throwsA(
        isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.currentPassword),
      ),
    );
    expect(gateway.calls, ['signIn:ratna@example.com']);
    gateway.calls.clear();
    await auth.changePassword('Laundry123!', 'NewPass123!');
    expect(gateway.calls, ['signIn:ratna@example.com', 'changePassword']);
    gateway.user = identity(google: true, password: false);
    await expectLater(
      auth.changePassword('NewPass123!', 'Other123!'),
      throwsA(
        isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.currentPassword),
      ),
    );
  });

  test('reset is sent for known and unknown addresses alike; limits surface', () async {
    await auth.sendPasswordReset('ada@example.com');
    await auth.sendPasswordReset('tidak-ada@example.com');
    expect(gateway.calls, ['reset:ada@example.com', 'reset:tidak-ada@example.com']);
    gateway.resetError = error('over_email_send_rate_limit', status: '429');
    await expectLater(
      auth.sendPasswordReset('ada@example.com'),
      throwsA(isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.requestLimit)),
    );
  });

  test('sign out clears the session and keeps the local rollback checkpoint', () async {
    await auth.signInWithPassword('ratna@example.com', 'Laundry123!');
    final restore = auth.checkpoint();
    restore();
    await auth.signOut();
    expect(auth.isSignedIn, isFalse);
    expect(auth.currentUserId, isNull);
    expect(auth.name, isEmpty);
    expect(auth.needsBusinessSetup, isFalse);
  });

  test('deletion calls the edge function, clears the session, and stays safe on failure', () async {
    await auth.signInWithPassword('ratna@example.com', 'Laundry123!');
    expect(await auth.deleteAccount(), isTrue);
    expect(gateway.calls.last, 'deleteAccount');
    expect(auth.isSignedIn, isFalse);
    expect(auth.currentUserId, isNull);

    gateway.user = identity();
    gateway.deleteError = error('server_error', status: '500');
    await expectLater(
      auth.deleteAccount(),
      throwsA(isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.unavailable)),
    );
    expect(auth.isSignedIn, isTrue);
    gateway.deleteError = error('over_request_rate_limit', status: '429');
    await expectLater(
      auth.deleteAccount(),
      throwsA(isA<AuthFailure>().having((e) => e.kind, 'kind', AuthFailureKind.requestLimit)),
    );
  });
}
