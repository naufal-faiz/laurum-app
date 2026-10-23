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
    this.userId = 'fake-user',
  });

  @override
  bool isSignedIn;
  @override
  String? get currentUserId => isSignedIn ? userId : null;
  final String userId;

  final List<String> authActionLogs = [];

  @override
  Future<bool> signInWithGoogle() async {
    authActionLogs.add('signInWithGoogle');
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
    isSignedIn = false;
    return true;
  }
}
