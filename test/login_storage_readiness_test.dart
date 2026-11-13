import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/state/account_identity.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'drift_app_harness.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final failsFirst in [false, true]) {
    testWidgets('first login waits for storage; recoverable failure=$failsFirst', (
      tester,
    ) async {
      final app = (await tester.runAsync(() => driftAppHarness(seed: false)))!;
      final opening = Completer<AccountStore?>();
      final auth = FakeAuthService(
        isSignedIn: false,
        needsBusinessSetup: true,
        userId: demoOwnerId,
      );
      var attempts = 0;
      final scope = ProviderContainer(
        overrides: [
          ...driftRepositoryOverrides(auth: auth, demoProposals: false),
          accountStoreProvider.overrideWith((ref) async {
            if (ref.watch(accountIdentityProvider) == null) return null;
            return ++attempts == 1 ? opening.future : app.store;
          }),
        ],
      );
      final router = createAppRouter(container: scope, initialLocation: '/masuk');
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        router.dispose();
        scope.dispose();
        app.container.dispose();
        await app.store.dispose();
        await app.store.db.close();
      });
      await pumpDriftApp(tester, scope, router);
      await scope.read(accountStoreProvider.future);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Lanjutkan dengan Google'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lanjutkan dengan Google'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Membuka data lokal'), findsOneWidget);
      expect(find.text('Gagal memuat info usaha'), findsNothing);
      expect(find.text('Kembali'), findsNothing);
      if (failsFirst) {
        opening.completeError(StateError('private/storage/path'));
        await tester.pumpAndSettle();
        expect(find.text('Penyimpanan belum dapat dibuka'), findsOneWidget);
        expect(find.text('Gagal memuat info usaha'), findsNothing);
        expect(find.textContaining('private/storage'), findsNothing);
        expect(scope.read(authSessionProvider).signedIn, isTrue);
        await tester.tap(find.text('Coba lagi'));
      } else {
        opening.complete(app.store);
      }
      await tester.runAsync(() => scope.read(accountStoreProvider.future));
      await tester.pumpAndSettle();
      expect(find.text('Info usaha'), findsOneWidget);
      expect(find.text('Gagal memuat info usaha'), findsNothing);
      expect(find.byType(AppTextField), findsNWidgets(4));
      expect(scope.read(authSessionProvider).signedIn, isTrue);
      expect(auth.authActionLogs.where((action) => action == 'signOut'), isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
}
