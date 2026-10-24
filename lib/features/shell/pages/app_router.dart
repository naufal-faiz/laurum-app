import 'package:go_router/go_router.dart';
import 'package:laurum/features/orders/pages/antrean_page.dart';
import 'package:laurum/features/printer/pages/printer_page.dart';
import 'package:laurum/features/shell/pages/placeholder_page.dart';
import 'package:laurum/features/shell/pages/placeholder_routes.dart';
import 'package:laurum/features/shell/pages/root_shell_page.dart';
import 'package:laurum/features/transactions/pages/payment_page.dart';
import 'package:laurum/features/transactions/pages/receipt_page.dart';
import 'package:laurum/features/transactions/pages/service_picker_page.dart';
import 'package:laurum/features/transactions/pages/transaction_page.dart';

GoRouter createAppRouter({String initialLocation = '/antrean'}) => GoRouter(
  initialLocation: initialLocation,
  errorBuilder: (context, state) => const PlaceholderPage(title: 'Halaman tidak ditemukan'),
  routes: [
    GoRoute(path: '/transaksi/baru', builder: (context, state) => const TransactionPage()),
    GoRoute(
      path: '/transaksi/baru/layanan',
      builder: (context, state) => const ServicePickerPage(),
    ),
    GoRoute(path: '/transaksi/baru/bayar', builder: (context, state) => const PaymentPage()),
    GoRoute(
      path: '/transaksi/nota/:id',
      builder: (context, state) => ReceiptPage(orderId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/lainnya/printer', builder: (context, state) => const PrinterPage()),
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
