import 'package:laurum/core/services/transaction_runner.dart';

abstract class AuthService {
  bool get isSignedIn;
  String? get currentUserId;
  String get email;
  bool get needsBusinessSetup;
  Future<void> completeBusinessSetup();
  Future<bool> signInWithGoogle();
  Future<void> signOut();
  Future<bool> deleteAccount();
}

class FakeAuthService implements AuthService, TransactionParticipant {
  @override
  void Function() checkpoint() {
    final signedIn = isSignedIn, setup = needsBusinessSetup;
    return () {
      isSignedIn = signedIn;
      needsBusinessSetup = setup;
    };
  }

  FakeAuthService({
    this.isSignedIn = true,
    this.userId = 'fake-user',
    this.email = '',
    this.needsBusinessSetup = false,
    this.signInSucceeds = true,
    this.deleteSucceeds = true,
  });

  @override
  bool isSignedIn;
  @override
  String? get currentUserId => isSignedIn ? userId : null;
  final String userId;
  @override
  final String email;
  @override
  bool needsBusinessSetup;
  final bool signInSucceeds, deleteSucceeds;
  @override
  Future<void> completeBusinessSetup() async => needsBusinessSetup = false;

  final List<String> authActionLogs = [];

  @override
  Future<bool> signInWithGoogle() async {
    authActionLogs.add('signInWithGoogle');
    if (!signInSucceeds) return false;
    isSignedIn = true;
    return true;
  }

  @override
  Future<void> signOut() async {
    authActionLogs.add('signOut');
    isSignedIn = false;
  }

  @override
  Future<bool> deleteAccount() async {
    authActionLogs.add('deleteAccount');
    if (!deleteSucceeds) return false;
    isSignedIn = false;
    needsBusinessSetup = true;
    return true;
  }
}
