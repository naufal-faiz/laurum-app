import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/fake_auth_account.dart';

void main() {
  late FakeAuthService auth;
  setUp(
    () => auth = FakeAuthService(
      isSignedIn: false,
      email: 'ratna@example.com',
      accounts: [
        const FakeAuthAccount(
          id: 'owner-001',
          email: 'ratna@example.com',
          name: 'Bu Ratna',
          password: 'Laundry123!',
        ),
      ],
    ),
  );
  test('password login normalizes email and never authenticates invalid credentials', () async {
    expect(await auth.signInWithPassword('unknown@example.com', 'Laundry123!'), isFalse);
    expect(await auth.signInWithPassword('ratna@example.com', 'wrong'), isFalse);
    expect(auth.isSignedIn, isFalse);
    expect(await auth.signInWithPassword(' RATNA@EXAMPLE.COM ', 'Laundry123!'), isTrue);
    expect(auth.name, 'Bu Ratna');
    expect(auth.usesPassword, isTrue);
    expect(auth.authActionLogs.join(), isNot(contains('Laundry123!')));
  });
  test('new registration requires confirmation and business setup', () async {
    await auth.signUp('new@example.com', 'NewPass123!', 'Nama Baru');
    expect(auth.isSignedIn, isFalse);
    expect(auth.awaitingEmail, isTrue);
    expect(await auth.confirmEmail(), isTrue);
    expect(auth.isSignedIn, isTrue);
    expect(auth.needsBusinessSetup, isTrue);
    expect(auth.name, 'Nama Baru');
    await auth.completeBusinessSetup();
    expect(auth.needsBusinessSetup, isFalse);
  });
  test('duplicate registration is generic and confirmation cannot take over account', () async {
    await auth.signUp('ratna@example.com', 'Attacker123!', 'Different');
    expect(auth.awaitingEmail, isTrue);
    expect(await auth.confirmEmail(), isFalse);
    expect(auth.isSignedIn, isFalse);
    expect(await auth.signInWithPassword('ratna@example.com', 'Attacker123!'), isFalse);
    expect(await auth.signInWithPassword('ratna@example.com', 'Laundry123!'), isTrue);
  });
  test('password change checks current secret; profile persists across login', () async {
    await auth.signInWithPassword('ratna@example.com', 'Laundry123!');
    await expectLater(auth.changePassword('wrong', 'NewPass123!'), throwsA(isA<AuthFailure>()));
    await auth.changePassword('Laundry123!', 'NewPass123!');
    await auth.updateProfile('Ratna Baru', '+6281234567890');
    await auth.signOut();
    expect(await auth.signInWithPassword('ratna@example.com', 'Laundry123!'), isFalse);
    expect(await auth.signInWithPassword('ratna@example.com', 'NewPass123!'), isTrue);
    expect(auth.name, 'Ratna Baru');
    expect(auth.phone, '+6281234567890');
    await auth.signOut();
    await auth.signInWithGoogle();
    expect(auth.usesPassword, isFalse);
    await expectLater(auth.changePassword('NewPass123!', 'Other123!'), throwsA(isA<AuthFailure>()));
  });
  test('reset has same observable response for known and unknown email', () async {
    await auth.sendPasswordReset('ratna@example.com');
    await auth.sendPasswordReset('unknown@example.com');
    expect(auth.authActionLogs, ['sendPasswordReset', 'sendPasswordReset']);
    expect(auth.isSignedIn, isFalse);
    auth.rateLimited = true;
    await expectLater(auth.sendPasswordReset('unknown@example.com'), throwsA(isA<AuthFailure>()));
  });
  test('snapshot restores credentials and profile when account cleanup rolls back', () async {
    await auth.signInWithPassword('ratna@example.com', 'Laundry123!');
    final restore = auth.checkpoint();
    await auth.deleteAccount();
    restore();
    expect(auth.isSignedIn, isTrue);
    expect(auth.name, 'Bu Ratna');
    await auth.signOut();
    expect(await auth.signInWithPassword('ratna@example.com', 'Laundry123!'), isTrue);
  });
}
