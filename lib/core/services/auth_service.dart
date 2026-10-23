abstract class AuthService {
  bool get isSignedIn;
  String? get currentUserId;
  Future<bool> signInWithGoogle();
  Future<void> signOut();
  Future<bool> deleteAccount();
}

class FakeAuthService implements AuthService {
  FakeAuthService({
    this.isSignedIn = true,
    this.currentUserId = 'dummy-owner-id',
  });

  @override
  bool isSignedIn;
  @override
  String? currentUserId;

  final List<String> authActionLogs = [];

  @override
  Future<bool> signInWithGoogle() async {
    authActionLogs.add('signInWithGoogle');
    isSignedIn = true;
    currentUserId = 'dummy-owner-id';
    return true;
  }

  @override
  Future<void> signOut() async {
    authActionLogs.add('signOut');
    isSignedIn = false;
    currentUserId = null;
  }

  @override
  Future<bool> deleteAccount() async {
    authActionLogs.add('deleteAccount');
    isSignedIn = false;
    currentUserId = null;
    return true;
  }
}
