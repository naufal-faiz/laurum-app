import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';

import 'antrean_test_host.dart';

const emptyQueue = AntreanData([], [], {}, {}, []);

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('loading resolves to empty queue and create action opens route', (tester) async {
    final pending = Completer<AntreanData>();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        antreanDataProvider.overrideWith((ref) => pending.future),
      ],
    );
    final host = await pumpAntrean(tester, container: scope, settle: false);
    await tester.pump();
    expect(find.byType(AppSkeleton), findsWidgets);
    pending.complete(emptyQueue);
    await tester.pumpAndSettle();
    expect(find.text('Belum ada order aktif'), findsOneWidget);
    await tester.tap(find.text('Transaksi baru').first);
    await tester.pumpAndSettle();
    expect(find.text('Buat transaksi'), findsWidgets);
    expect(host.router.canPop(), isTrue);
  });
  testWidgets('filter with no results stays selectable', (tester) async {
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        antreanDataProvider.overrideWithValue(const AsyncData(emptyQueue)),
      ],
    );
    scope.read(antreanFilterProvider.notifier).select(2);
    await pumpAntrean(tester, container: scope);
    expect(find.text('Tidak ada order di status ini'), findsOneWidget);
    await tester.tap(find.text('Semua 0'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada order aktif'), findsOneWidget);
  });
  testWidgets('failed load retries through repository state', (tester) async {
    var calls = 0;
    final scope = ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        ...dummyRepositoryOverrides,
        antreanDataProvider.overrideWith((ref) async {
          if (calls++ == 0) throw Exception('test load failure');
          return emptyQueue;
        }),
      ],
    );
    await pumpAntrean(tester, container: scope);
    expect(find.text('Gagal memuat data'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.text('Belum ada order aktif'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('320px with text 2x does not overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final host = await pumpAntrean(tester, textScale: 2);
    expect(tester.takeException(), isNull);
    host.container.read(antreanFilterProvider.notifier).select(2);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
