import 'package:go_router/go_router.dart';
import 'package:laurum/features/orders/pages/antrean_page.dart';
import 'package:laurum/features/shell/pages/placeholder_page.dart';
import 'package:laurum/features/shell/pages/placeholder_routes.dart';
import 'package:laurum/features/shell/pages/root_shell_page.dart';

GoRouter createAppRouter({String initialLocation = '/antrean'}) => GoRouter(
  initialLocation: initialLocation,
  errorBuilder: (context, state) => const PlaceholderPage(title: 'Halaman tidak ditemukan'),
  routes: [
    for (final route in placeholderRoutes.entries)
      GoRoute(
        path: route.key,
        builder: (context, state) => PlaceholderPage(title: route.value),
      ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => RootShellPage(navigationShell: shell),
      branches: [
        for (final route in tabRoutes.entries)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: route.key,
                builder: (context, state) => route.key == '/antrean'
                    ? const AntreanPage()
                    : PlaceholderPage(title: route.value, isTab: true),
              ),
            ],
          ),
      ],
    ),
  ],
);
