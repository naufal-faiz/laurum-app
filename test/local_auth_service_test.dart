import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/features/auth/data/local_auth_service.dart';

void main() {
  test('demo can log back into the same UUID; release starts signed out and isolated', () async {
    final demo = localAuthService(demo: true, demoOwnerId: demoOwnerId);
    await demo.signOut();
    expect(await demo.signInWithPassword('ratna@example.com', 'Laundry123!'), isTrue);
    expect(demo.currentUserId, demoOwnerId);
    final release = localAuthService(demo: false, demoOwnerId: demoOwnerId);
    expect(release.isSignedIn, isFalse);
    expect(release.needsBusinessSetup, isTrue);
    await release.signInWithGoogle();
    expect(release.currentUserId, isNot(demoOwnerId));
    expect(release.needsBusinessSetup, isTrue);
  });
}
