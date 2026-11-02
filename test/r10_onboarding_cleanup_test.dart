import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/state/password_reset.dart';
import 'package:laurum/features/business/state/business_info_controller.dart';

import 'r10_test_host.dart';

void main() {
  test('new signup cannot reuse cached business form from previous login', () async {
    final scope = r10Scope(signedIn: true);
    addTearDown(scope.dispose);
    expect((await scope.read(businessInfoProvider.future)).name, 'Berkah Laundry');
    final session = scope.read(authSessionProvider.notifier);
    await session.signOut();
    expect(await session.signUp('new@example.com', 'NewPass123!', 'Nama Baru'), isTrue);
    expect(await session.confirmEmail(), isTrue);
    expect((await scope.read(businessInfoProvider.future)).name, '');
    expect(scope.read(authSessionProvider).needsSetup, isTrue);
  });
  test('delete clears reset draft/cooldown and removes password credentials', () async {
    final scope = await r10PasswordScope();
    addTearDown(scope.dispose);
    final reset = scope.read(passwordResetProvider.notifier)..email('ratna@example.com');
    expect(await reset.submit(), isTrue);
    expect(scope.read(passwordResetProvider).remaining, 60);
    expect(await scope.read(authSessionProvider.notifier).deleteAccount(), isTrue);
    expect(scope.read(passwordResetProvider).email, '');
    expect(scope.read(passwordResetProvider).remaining, 0);
    expect(
      await scope.read(authServiceProvider).signInWithPassword('ratna@example.com', 'Laundry123!'),
      isFalse,
    );
  });
}
