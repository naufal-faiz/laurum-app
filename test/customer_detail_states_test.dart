import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/customers/state/customer_detail_data.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('detail loads then handles a missing customer', (tester) async {
    final pending = Completer<CustomerDetailData?>();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        customerDetailProvider('missing').overrideWith((ref) => pending.future),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/pelanggan/missing', settle: false);
    await tester.pump();
    expect(find.byType(AppSkeleton), findsWidgets);
    pending.complete(null);
    await tester.pumpAndSettle();
    expect(find.text('Pelanggan tidak ditemukan'), findsOneWidget);
  });
  testWidgets('detail retry recovers after load failure', (tester) async {
    var calls = 0;
    final scope = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        ...dummyRepositoryOverrides,
        customerDetailProvider('test').overrideWith((ref) async {
          if (calls++ == 0) throw Exception('load failed');
          return null;
        }),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/pelanggan/test');
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.text('Pelanggan tidak ditemukan'), findsOneWidget);
  });
  testWidgets('detail at 320px with 2x text and empty history remains usable', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/pelanggan/cust-014', textScale: 2);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Belum ada nota'), 500);
    await tester.pumpAndSettle();
    expect(find.text('Belum ada nota'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
