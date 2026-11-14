import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/main_dummy.dart';

import 'test_fonts.dart';

Future<ProviderContainer> pumpUnscaledCustomerDetail(
  WidgetTester tester, {
  double width = 390,
  double scale = 1,
  String customerId = 'cust-001',
}) async {
  await loadTestFonts();
  tester.view.physicalSize = Size(width, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
  final router = createAppRouter(container: scope, initialLocation: '/pelanggan/$customerId');
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    scope.dispose();
  });
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: scope,
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
          child: RepaintBoundary(key: const ValueKey('customer-detail-golden'), child: child!),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return scope;
}
