import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/state/password_reset.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  test('reset response is uniform, cooldown survives edits and clock controls retry', () async {
    var now = DateTime(2026, 10, 16);
    final auth = FakeAuthService(isSignedIn: false);
    final scope = ProviderContainer(
      overrides: dummyOverrides(authService: auth, clock: () => now),
    );
    addTearDown(scope.dispose);
    final reset = scope.read(passwordResetProvider.notifier);
    reset.email('ratna@example.com');
    expect(await reset.submit(), isTrue);
    final first = scope.read(passwordResetProvider);
    expect(first.sent, isTrue);
    expect(first.remaining, 60);
    reset.email('unknown@example.com');
    expect(await reset.submit(), isFalse);
    expect(auth.authActionLogs, ['sendPasswordReset']);
    now = now.add(const Duration(seconds: 60));
    reset.refreshCooldown();
    expect(await reset.submit(), isTrue);
    expect(scope.read(passwordResetProvider).sent, first.sent);
    expect(scope.read(passwordResetProvider).error, isNull);
    expect(auth.authActionLogs, ['sendPasswordReset', 'sendPasswordReset']);
  });
}
