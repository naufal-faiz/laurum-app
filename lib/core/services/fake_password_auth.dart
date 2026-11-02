import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/fake_auth_accounts.dart';

mixin FakePasswordAuth implements AuthService {
  FakeAuthAccounts get accountStore;
  List<String> get authActionLogs;
  bool get rateLimited;
  set isSignedIn(bool value);
  set needsBusinessSetup(bool value);
  @override
  String get email => accountStore.profile.email;
  @override
  String get name => accountStore.profile.name;
  @override
  String get phone => accountStore.profile.phone;
  @override
  bool get usesPassword => accountStore.usesPassword;
  @override
  bool get googleLinked => accountStore.profile.googleLinked;
  @override
  bool get awaitingEmail => accountStore.awaitingEmail;
  void checkAuthRate() {
    if (rateLimited) throw const AuthFailure(AuthFailureKind.requestLimit);
  }

  @override
  Future<bool> signInWithPassword(String email, String password) async {
    checkAuthRate();
    authActionLogs.add('signInWithPassword');
    final ok = accountStore.login(email, password);
    if (ok) {
      isSignedIn = true;
      needsBusinessSetup = accountStore.profile.needsSetup;
    }
    return ok;
  }

  @override
  Future<void> signUp(String email, String password, String name) async {
    checkAuthRate();
    authActionLogs.add('signUp');
    accountStore.register(email, password, name);
    isSignedIn = false;
  }

  @override
  Future<bool> confirmEmail() async {
    checkAuthRate();
    authActionLogs.add('confirmEmail');
    if (!accountStore.confirm()) return false;
    isSignedIn = true;
    needsBusinessSetup = true;
    return true;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    checkAuthRate();
    authActionLogs.add('sendPasswordReset');
  }

  @override
  Future<void> updateProfile(String name, String phone) async {
    checkAuthRate();
    authActionLogs.add('updateProfile');
    accountStore.updateProfile(name, phone);
  }

  @override
  Future<void> changePassword(String current, String next) async {
    checkAuthRate();
    authActionLogs.add('changePassword');
    accountStore.changePassword(current, next);
  }
}
