import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/shell/pages/app_router.dart';

import 'drift_app_harness.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('storage loading/error hides raw errors and retry displays account data', (
    tester,
  ) async {
    final app = (await tester.runAsync(driftAppHarness))!;
    app.container.dispose();
    final opening = Completer<AccountStore?>();
    var attempt = 0;
    final c = ProviderContainer(
      overrides: [
        ...driftRepositoryOverrides(),
        accountStoreProvider.overrideWith(
          (ref) => ++attempt == 1 ? opening.future : Future.value(app.store),
        ),
      ],
    );
    final router = createAppRouter(container: c, initialLocation: '/antrean');
    addTearDown(() async {
      router.dispose();
      c.dispose();
      await app.store.dispose();
      await app.store.db.close();
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: LaurumApp(router: router),
      ),
    );
    expect(find.text('Membuka data lokal'), findsOneWidget);
    opening.completeError(StateError('private/file/password/token'));
    await tester.pumpAndSettle();
    expect(find.text('Penyimpanan belum dapat dibuka'), findsOneWidget);
    expect(find.textContaining('private/file'), findsNothing);
    await tester.tap(find.text('Coba lagi'));
    await tester.pump();
    await tester.runAsync(() async {
      await c.read(accountStoreProvider.future);
      await Future.wait([
        c.read(antreanDataProvider.future),
        c.read(customerDirectoryProvider.future),
        c.read(reportViewProvider.future),
      ]);
    });
    await tester.pumpAndSettle();
    expect(find.text('12 order aktif'), findsOneWidget);
    expect(attempt, 2);
    expect(tester.takeException(), isNull);
  });
}
