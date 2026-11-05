import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/data/auth_fixtures.dart';
import 'package:laurum/features/auth/data/dummy_account_data.dart';

// B3 replaces this stub. Credentials/sessions are never persisted to the business DB.
AuthService localAuthService({required bool demo, required String demoOwnerId}) => demo
    ? FakeAuthService(
        userId: demoOwnerId,
        email: dummyGoogleEmail,
        accounts: dummyAuthAccounts(ownerId: demoOwnerId),
      )
    : FakeAuthService(
        isSignedIn: false,
        userId: const IdGenerator().derived('laurum-local-auth', 'owner'),
        email: dummyGoogleEmail,
        needsBusinessSetup: true,
      );
