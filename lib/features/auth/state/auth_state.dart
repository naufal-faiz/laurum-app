import 'package:laurum/core/services/auth_service.dart';

typedef AuthState = ({
  bool signedIn,
  bool needsSetup,
  bool awaitingEmail,
  bool recovering,
  bool busy,
  String? error,
});
AuthState authSnapshot(AuthService auth, {bool busy = false, String? error}) => (
  signedIn: auth.isSignedIn,
  needsSetup: auth.needsBusinessSetup,
  awaitingEmail: auth.awaitingEmail,
  recovering: auth.recovering,
  busy: busy,
  error: error,
);
