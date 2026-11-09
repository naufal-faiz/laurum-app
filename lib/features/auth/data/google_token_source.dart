import 'package:google_sign_in/google_sign_in.dart';
import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/features/auth/data/auth_gateway.dart';

/// Native Google account picker. The Web client ID is public and comes from
/// `--dart-define`; without it Google sign-in reports "unavailable" instead of
/// opening a broken picker.
class GoogleSignInTokenSource implements GoogleTokenSource {
  GoogleSignInTokenSource(this.serverClientId);
  final String serverClientId;
  Future<void>? _ready;

  @override
  Future<String?> idToken() async {
    if (serverClientId.isEmpty) throw const AuthFailure(AuthFailureKind.unavailable);
    final google = GoogleSignIn.instance;
    await (_ready ??= google.initialize(serverClientId: serverClientId));
    try {
      final account = await google.authenticate();
      final token = account.authentication.idToken;
      if (token == null || token.isEmpty) throw const AuthFailure(AuthFailureKind.unavailable);
      return token;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      throw const AuthFailure(AuthFailureKind.unavailable);
    }
  }
}
