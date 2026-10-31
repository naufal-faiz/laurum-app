import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/features/transactions/pages/payment_page.dart';
import 'package:laurum/features/transactions/pages/service_picker_page.dart';
import 'package:laurum/features/transactions/pages/transaction_page.dart';

/// Alur transaksi memakai transisi fade + lift agar masuk tidak terasa kaku.
final transactionRoutes = <RouteBase>[
  _smoothRoute('/transaksi/baru', const TransactionPage()),
  _smoothRoute('/transaksi/baru/layanan', const ServicePickerPage()),
  _smoothRoute('/transaksi/baru/bayar', const PaymentPage()),
];

GoRoute _smoothRoute(String path, Widget page) =>
    GoRoute(path: path, pageBuilder: (context, state) => _smoothPage(state, page));

CustomTransitionPage<void> _smoothPage(GoRouterState state, Widget page) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: page,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );
