import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/shell/pages/app_router.dart';

import 'drift_app_harness.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('empty Drift business displays empty state and create action', (tester) async {
    final app = (await tester.runAsync(() => driftAppHarness(seed: false)))!;
    final router = createAppRouter(container: app.container);
    addTearDown(() async {
      router.dispose();
      app.container.dispose();
      await app.store.dispose();
      await app.store.db.close();
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: app.container,
        child: LaurumApp(router: router),
      ),
    );
    await tester.runAsync(() => app.container.read(antreanDataProvider.future));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada order aktif'), findsOneWidget);
    expect(find.text('Transaksi baru'), findsWidgets);
    expect(find.textContaining('Pak Dedi'), findsNothing);
    expect(app.store.sync.pendingChanges, 0);
    expect(tester.takeException(), isNull);
  });
}
