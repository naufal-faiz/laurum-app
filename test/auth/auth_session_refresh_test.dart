import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/fake_auth_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/auth/state/account_identity.dart';
import 'package:laurum/features/auth/state/auth_session.dart';

class StreamingAuthService extends FakeAuthService {
  StreamingAuthService({required this.changes, super.isSignedIn});
  final Stream<void> changes;

  @override
  Stream<void> get sessionChanges => changes;
}

void main() {
  test('a deep link session refreshes the auth state', () async {
    final changes = StreamController<void>.broadcast();
    final auth = StreamingAuthService(isSignedIn: false, changes: changes.stream);
    final container = ProviderContainer(
      overrides: [authServiceProvider.overrideWithValue(auth)],
    );
    addTearDown(container.dispose);
    expect(container.read(authSessionProvider).signedIn, isFalse);

    auth.isSignedIn = true;
    changes.add(null);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(authSessionProvider).signedIn, isTrue);
    expect(container.read(accountIdentityProvider), auth.currentUserId);
    await changes.close();
  });
}
