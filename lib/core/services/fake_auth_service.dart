import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/fake_auth_account.dart';
import 'package:laurum/core/services/fake_auth_accounts.dart';
import 'package:laurum/core/services/fake_password_auth.dart';
import 'package:laurum/core/services/transaction_runner.dart';

class FakeAuthService with FakePasswordAuth implements AuthService, TransactionParticipant {
  FakeAuthService({
    this.isSignedIn = true,
    this.userId = 'fake-user',
    String email = '',
    this.needsBusinessSetup = false,
    this.signInSucceeds = true,
    this.deleteSucceeds = true,
    this.rateLimited = false,
    this.recovering = false,
    Iterable<FakeAuthAccount> accounts = const [],
    IdGenerator ids = const IdGenerator(),
  }) : accountStore = FakeAuthAccounts(
         FakeAuthAccount(
           id: userId,
           email: email,
           googleLinked: true,
           needsSetup: needsBusinessSetup,
         ),
         accounts,
         ids: ids,
       );
  @override
  final FakeAuthAccounts accountStore;
  @override
  final List<String> authActionLogs = [];
  @override
  bool rateLimited;
  @override
  bool isSignedIn;
  @override
  bool needsBusinessSetup;
  @override
  bool recovering;
  final String userId;
  final bool signInSucceeds, deleteSucceeds;
  @override
  String? get currentUserId => isSignedIn ? accountStore.profile.id : null;
  @override
  void Function() checkpoint() {
    final signedIn = isSignedIn, setup = needsBusinessSetup;
    final restore = accountStore.checkpoint();
    return () {
      restore();
      isSignedIn = signedIn;
      needsBusinessSetup = setup;
    };
  }

  @override
  Future<void> completeBusinessSetup() async {
    accountStore.finishSetup();
    needsBusinessSetup = false;
  }

  @override
  Future<void> setRecoveredPassword(String password) async {
    await super.setRecoveredPassword(password);
    recovering = false;
  }

  @override
  Future<bool> signInWithGoogle() async {
    checkAuthRate();
    authActionLogs.add('signInWithGoogle');
    if (!signInSucceeds) return false;
    accountStore.google(needsSetup: needsBusinessSetup);
    needsBusinessSetup = accountStore.profile.needsSetup;
    isSignedIn = true;
    return true;
  }

  @override
  Future<void> signOut() async {
    authActionLogs.add('signOut');
    isSignedIn = false;
    accountStore.cancelVerification();
  }

  @override
  Future<bool> deleteAccount() async {
    authActionLogs.add('deleteAccount');
    if (!deleteSucceeds) return false;
    accountStore.delete();
    isSignedIn = false;
    needsBusinessSetup = true;
    return true;
  }
}
