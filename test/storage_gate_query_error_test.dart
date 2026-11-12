import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';

import 'drift_app_harness.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('initial query error leaves loader for page error and keeps retry', (tester) async {
    final app = (await tester.runAsync(driftAppHarness))!;
    final report = await tester.runAsync(() => app.container.read(weeklyReportViewProvider.future));
    var reads = 0;
    final scope = ProviderContainer(
      overrides: [
        ...driftRepositoryOverrides(),
        accountStoreProvider.overrideWith((ref) async => app.store),
        weeklyReportViewProvider.overrideWith((ref) async {
          if (++reads == 1) throw StateError('private/file/password/token');
          return report!;
        }),
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
    await tester.runAsync(() async {
      await scope.read(accountStoreProvider.future);
      await Future.wait([
        scope.read(antreanDataProvider.future),
        scope.read(customerDirectoryProvider.future),
      ]);
    });
    await tester.pumpAndSettle();
    expect(find.byType(AppLoader), findsNothing);
    expect(find.text('Gagal memuat beranda'), findsOneWidget);
    expect(find.text('Penyimpanan belum dapat dibuka'), findsNothing);
    expect(find.textContaining('private/file'), findsNothing);
    await tester.tap(find.text('Coba lagi'));
    await tester.runAsync(
      () => Future.wait([
        scope.read(antreanDataProvider.future),
        scope.read(customerDirectoryProvider.future),
        scope.read(weeklyReportViewProvider.future),
      ]),
    );
    await tester.pumpAndSettle();
    expect(reads, 2);
    expect(find.text('Selamat datang kembali,'), findsOneWidget);
    expect(find.byType(AppLoader), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
