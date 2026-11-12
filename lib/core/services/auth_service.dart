export 'package:laurum/core/services/fake_auth_service.dart';

abstract class AuthService {
  bool get isSignedIn;
  String? get currentUserId;
  String get email;
  String get name;
  String get phone;
  bool get usesPassword;
  bool get googleLinked;
  bool get awaitingEmail;
  bool get needsBusinessSetup;

  /// True when a recovery link must set a new password before entering.
  bool get recovering;

  /// Emits when the real backend session changes without a local call.
  Stream<void> get sessionChanges;
  Future<void> completeBusinessSetup();
  Future<bool> signInWithGoogle();
  Future<bool> signInWithPassword(String email, String password);
  Future<void> signUp(String email, String password, String name);
  Future<bool> confirmEmail();
  Future<void> sendPasswordReset(String email);
  Future<void> updateProfile(String name, String phone);
  Future<void> changePassword(String current, String next);

  /// Sets a password from a recovery session; no old password is required.
  Future<void> setRecoveredPassword(String password);
  Future<void> signOut();
  Future<bool> deleteAccount();
}
