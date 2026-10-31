import 'package:go_router/go_router.dart';
import 'package:laurum/features/auth/pages/sign_in_page.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/sync/pages/sync_page.dart';

String? authRedirect(AuthState auth, GoRouterState state) {
  final path = state.uri.path;
  if (!auth.signedIn) return path == '/masuk' ? null : '/masuk';
  if (auth.busy && path == '/masuk') return null;
  if (auth.needsSetup) {
    return path == '/lainnya/info-usaha' && state.uri.queryParameters['onboarding'] == '1'
        ? null
        : '/lainnya/info-usaha?onboarding=1';
  }
  if (path == '/lainnya/info-usaha' && state.uri.queryParameters['onboarding'] == '1') {
    return '/antrean';
  }
  return path == '/masuk' ? '/antrean' : null;
}

final authRoutes = <RouteBase>[
  GoRoute(path: '/masuk', builder: (context, state) => const SignInPage()),
  GoRoute(path: '/lainnya/sinkronisasi', builder: (context, state) => const SyncPage()),
];
