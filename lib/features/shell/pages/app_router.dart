import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/features/auth/pages/auth_routes.dart';
import 'package:laurum/features/auth/state/auth_router_refresh.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/beranda/pages/beranda_page.dart';
import 'package:laurum/features/customers/pages/customer_deposit_page.dart';
import 'package:laurum/features/customers/pages/customer_detail_page.dart';
import 'package:laurum/features/customers/pages/customer_directory_page.dart';
import 'package:laurum/features/customers/pages/customer_import_page.dart';
import 'package:laurum/features/customers/pages/customer_savings_history_page.dart';
import 'package:laurum/features/orders/pages/antrean_page.dart';
import 'package:laurum/features/orders/pages/order_detail_page.dart';
import 'package:laurum/features/orders/pages/order_edit_page.dart';
import 'package:laurum/features/proposals/pages/ai_routes.dart';
import 'package:laurum/features/reports/pages/outstanding_page.dart';
import 'package:laurum/features/reports/pages/report_page.dart';
import 'package:laurum/features/settings/pages/settings_page.dart';
import 'package:laurum/features/shell/pages/lainnya_routes.dart';
import 'package:laurum/features/shell/pages/placeholder_page.dart';
import 'package:laurum/features/shell/pages/placeholder_routes.dart';
import 'package:laurum/features/shell/pages/root_shell_page.dart';
import 'package:laurum/features/transactions/pages/receipt_page.dart';
import 'package:laurum/features/transactions/pages/service_picker_page.dart';
import 'package:laurum/features/transactions/pages/transaction_routes.dart';

GoRouter createAppRouter({
  required ProviderContainer container,
  String initialLocation = '/antrean',
}) => GoRouter(
  initialLocation: initialLocation,
  redirect: (context, state) => authRedirect(container.read(authSessionProvider), state),
  refreshListenable: container.read(authRouterRefreshProvider),
  errorBuilder: (context, state) => const PlaceholderPage(title: 'Halaman tidak ditemukan'),
  routes: [
    ...transactionRoutes,
    ...authRoutes,
    ...aiRoutes,
    GoRoute(
      path: '/transaksi/nota/:id',
      builder: (context, state) => ReceiptPage(orderId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/order/:id/edit',
      builder: (context, state) => OrderEditPage(orderId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/order/:id/edit/layanan',
      builder: (context, state) => const ServicePickerPage(),
    ),
    GoRoute(
      path: '/order/:id',
      builder: (context, state) => OrderDetailPage(orderId: state.pathParameters['id']!),
    ),
    ...lainnyaRoutes,
    for (final route in placeholderRoutes.entries)
      GoRoute(
        path: route.key,
        builder: (context, state) => PlaceholderPage(title: route.value),
      ),
    GoRoute(
      path: '/pelanggan/impor',
      builder: (context, state) => const CustomerImportPage(),
    ),
    GoRoute(
      path: '/pelanggan/:id/setor',
      builder: (context, state) => CustomerDepositPage(customerId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/pelanggan/:id/tabungan',
      builder: (context, state) =>
          CustomerSavingsHistoryPage(customerId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/laporan/piutang',
      builder: (context, state) => const OutstandingPage(),
    ),
    GoRoute(
      path: '/pelanggan/:id',
      builder: (context, state) => CustomerDetailPage(customerId: state.pathParameters['id']!),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => RootShellPage(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/beranda', builder: (context, state) => const BerandaPage()),
          ],
        ),
        for (final route in tabRoutes.entries.skip(1))
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: route.key,
                builder: (context, state) => switch (route.key) {
                  '/antrean' => const AntreanPage(),
                  '/pelanggan' => const CustomerDirectoryPage(),
                  '/lainnya' => const SettingsPage(),
                  _ => PlaceholderPage(title: route.value, isTab: true),
                },
              ),
              if (route.key == '/lainnya')
                // Legacy deep link: Laporan has no nav slot since 10 Nov 2026.
                GoRoute(path: '/laporan', builder: (context, state) => const ReportPage()),
            ],
          ),
      ],
    ),
  ],
);
