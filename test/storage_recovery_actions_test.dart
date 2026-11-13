import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/persistence/account_storage.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/shell/pages/app_router.dart';

import 'drift_app_harness.dart';

class RecoverableStorage extends AccountStorage {
  RecoverableStorage(this.store);
  final AccountStore store;
  int closes = 0;
  @override
  Future<AccountStore?> activate(String? ownerId) async {
    if (ownerId == null) return null;
    if (closes == 0) throw StateError('private/database/failure');
    return store;
  }

  @override
  Future<void> close() async {
    closes++;
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final retry in [true, false]) {
    testWidgets('storage failure has a working recovery action; retry=$retry', (tester) async {
      final app = (await tester.runAsync(driftAppHarness))!;
      final auth = FakeAuthService(userId: demoOwnerId);
      final storage = RecoverableStorage(app.store);
      final scope = ProviderContainer(
        overrides: [
          ...driftRepositoryOverrides(auth: auth),
          accountStorageProvider.overrideWithValue(storage),
        ],
      );
      final router = createAppRouter(container: scope);
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        router.dispose();
        scope.dispose();
        app.container.dispose();
        await app.store.dispose();
        await app.store.db.close();
      });
      await pumpDriftApp(tester, scope, router);
      await tester.pumpAndSettle();
      expect(find.text('Penyimpanan belum dapat dibuka'), findsOneWidget);
      await tester.tap(find.text(retry ? 'Coba lagi' : 'Keluar akun'));
      await tester.pump();
      if (retry) {
        await tester.runAsync(() async {
          await scope.read(accountStoreProvider.future);
          await Future.wait([
            scope.read(antreanDataProvider.future),
            scope.read(customerDirectoryProvider.future),
            scope.read(weeklyReportViewProvider.future),
          ]);
        });
      }
      await tester.pumpAndSettle();
      expect(find.text('Penyimpanan belum dapat dibuka'), findsNothing);
      expect(scope.read(authSessionProvider).signedIn, retry);
      if (retry) {
        expect(storage.closes, 1);
      } else {
        expect(router.routeInformationProvider.value.uri.path, '/masuk');
      }
      expect(await app.store.customers.getCustomers(), isNotEmpty);
      expect(tester.takeException(), isNull);
    });
  }
}
