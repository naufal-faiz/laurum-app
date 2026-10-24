import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/customers/pages/customer_directory_data.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('loading resolves to empty directory with add and import actions', (tester) async {
    final pending = Completer<List<CustomerDirectoryRow>>();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        customerDirectoryProvider.overrideWith((ref) => pending.future),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/pelanggan', settle: false);
    await tester.pump();
    expect(find.byType(AppSkeleton), findsWidgets);
    pending.complete([]);
    await tester.pumpAndSettle();
    expect(find.text('Belum ada pelanggan'), findsOneWidget);
    expect(find.text('Pelanggan baru'), findsOneWidget);
    expect(find.text('Impor kontak'), findsOneWidget);
  });

  testWidgets('failed directory can retry', (tester) async {
    var calls = 0;
    final scope = ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        ...dummyRepositoryOverrides,
        customerDirectoryProvider.overrideWith((ref) async {
          if (calls++ == 0) throw Exception('test load failure');
          return [];
        }),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/pelanggan');
    expect(find.text('Gagal memuat data'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada pelanggan'), findsOneWidget);
    expect(calls, 2);
  });

  testWidgets('320px at 2x text keeps directory usable', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/pelanggan', textScale: 2);
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField), 'Dedi');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
