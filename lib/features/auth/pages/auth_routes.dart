import 'package:go_router/go_router.dart';
import 'package:laurum/features/auth/pages/check_email_page.dart';
import 'package:laurum/features/auth/pages/manage_account_page.dart';
import 'package:laurum/features/auth/pages/new_password_page.dart';
import 'package:laurum/features/auth/pages/password_reset_page.dart';
import 'package:laurum/features/auth/pages/sign_in_page.dart';
import 'package:laurum/features/auth/pages/sign_up_page.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/sync/pages/sync_page.dart';

String? authRedirect(AuthState auth, GoRouterState state) {
  final path = state.uri.path;
  final public = {'/masuk', '/daftar', '/lupa-password', '/cek-email'}.contains(path);
  if (auth.recovering) return path == '/password-baru' ? null : '/password-baru';
  if (!auth.signedIn) {
    if (path == '/cek-email' && !auth.awaitingEmail) return '/masuk';
    return public ? null : '/masuk';
  }
  if (auth.busy && public) return null;
  if (auth.needsSetup) {
    return path == '/lainnya/info-usaha' && state.uri.queryParameters['onboarding'] == '1'
        ? null
        : '/lainnya/info-usaha?onboarding=1';
  }
  if (path == '/lainnya/info-usaha' && state.uri.queryParameters['onboarding'] == '1') {
    return '/beranda';
  }
  return public ? '/beranda' : null;
}

final authRoutes = <RouteBase>[
  GoRoute(path: '/masuk', builder: (context, state) => const SignInPage()),
  GoRoute(path: '/daftar', builder: (context, state) => const SignUpPage()),
  GoRoute(path: '/cek-email', builder: (context, state) => const CheckEmailPage()),
  GoRoute(path: '/lupa-password', builder: (context, state) => const PasswordResetPage()),
  GoRoute(path: '/password-baru', builder: (context, state) => const NewPasswordPage()),
  GoRoute(path: '/lainnya/akun', builder: (context, state) => const ManageAccountPage()),
  GoRoute(path: '/lainnya/sinkronisasi', builder: (context, state) => const SyncPage()),
];
