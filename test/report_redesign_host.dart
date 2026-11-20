import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/pages/report_page.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/main_dummy.dart';

import 'test_fonts.dart';

Future<ProviderContainer> pumpReportUnscaled(
  WidgetTester tester, {
  double width = 390,
  double scale = 1,
  int period = 1,
}) async {
  await loadTestFonts();
  tester.view.physicalSize = Size(width, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
  scope.read(reportPeriodProvider.notifier).select(period);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    scope.dispose();
  });
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: scope,
      child: MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: const RepaintBoundary(
          key: ValueKey('report-unscaled-golden'),
          child: Scaffold(body: ReportPage()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return scope;
}
