import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/auth/widgets/sign_in_section.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

class DeferredRestore extends FakeSyncService {
  final _gate = Completer<void>();
  void finish() => _gate.complete();
  @override
  Future<void> syncNow() async {
    await _gate.future;
    await super.syncNow();
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('restoration stays on login with disabled Google action until ready', (tester) async {
    final sync = DeferredRestore();
    addTearDown(sync.dispose);
    final scope = ProviderContainer(
      overrides: dummyOverrides(authService: FakeAuthService(isSignedIn: false), syncService: sync),
    );
    await pumpAntrean(tester, container: scope, location: '/masuk');
    await tester.ensureVisible(find.text('Lanjutkan dengan Google'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjutkan dengan Google'));
    await tester.pumpAndSettle();
    expect(find.text('Memulihkan data...'), findsOneWidget);
    expect(
      tester
          .widget<InkWell>(
            find.descendant(
              of: find.byType(SignInSection),
              matching: find.byType(InkWell),
            ),
          )
          .onTap,
      isNull,
    );
    sync.finish();
    await tester.pumpAndSettle();
    expect(find.text('Antrean aktif'), findsOneWidget);
  });
}
