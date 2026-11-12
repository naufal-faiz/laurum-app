import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:lottie/lottie.dart';

import 'drift_app_harness.dart';
import 'test_fonts.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
    await AssetLottie('assets/animations/laurum-loader.json').load();
    await loadTestFonts();
  });
  testWidgets('one centered local loader survives initial reads and leaves refresh mounted', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
      disableAnimations: true,
    );
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final app = (await tester.runAsync(driftAppHarness))!;
    final queueValue = await tester.runAsync(() => app.container.read(antreanDataProvider.future));
    final peopleValue = await tester.runAsync(
      () => app.container.read(customerDirectoryProvider.future),
    );
    final reportValue = await tester.runAsync(
      () => app.container.read(weeklyReportViewProvider.future),
    );
    final opening = Completer<AccountStore?>();
    final queue = Completer<AntreanData>();
    final people = Completer<List<CustomerDirectoryRow>>();
    final report = Completer<ReportView>();
    var reads = 0;
    final refreshed = Completer<AntreanData>();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        storageGateEnabledProvider.overrideWithValue(true),
        accountStoreProvider.overrideWith((ref) => opening.future),
        antreanDataProvider.overrideWith((ref) => ++reads == 1 ? queue.future : refreshed.future),
        customerDirectoryProvider.overrideWith((ref) => people.future),
        weeklyReportViewProvider.overrideWith((ref) => report.future),
      ],
    );
    final router = createAppRouter(container: scope);
    addTearDown(() async {
      router.dispose();
      scope.dispose();
      app.container.dispose();
      await app.store.dispose();
      await app.store.db.close();
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: scope,
        child: LaurumApp(router: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    final gate = find.byKey(const ValueKey('local-storage-loading'));
    expect(find.byType(AppLoader), findsOneWidget);
    expect(tester.getCenter(gate), const Offset(195, 422));
    expect(tester.widget<Text>(find.text('Membuka data lokal')).textAlign, TextAlign.center);
    expect(find.text('Tunggu sebentar, data usaha sedang disiapkan.'), findsOneWidget);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/local_storage_loading.png'),
    );
    final gateElement = tester.element(gate);
    opening.complete(app.store);
    await tester.pump();
    queue.complete(queueValue!);
    people.complete(peopleValue!);
    await tester.pump();
    expect(tester.element(gate), same(gateElement));
    expect(find.byType(AppSkeleton), findsNothing);
    report.complete(reportValue!);
    await tester.pumpAndSettle();
    expect(gate, findsNothing);
    expect(find.byType(AppLoader), findsNothing);
    expect(find.text('Selamat datang kembali,'), findsOneWidget);
    final navigator = tester.element(find.byType(Navigator).first);
    scope.invalidate(antreanDataProvider);
    await tester.pump();
    expect(gate, findsNothing);
    expect(tester.element(find.byType(Navigator).first), same(navigator));
    refreshed.complete(queueValue);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
