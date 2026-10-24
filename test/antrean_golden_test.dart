import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/orders/pages/antrean_controller.dart';
import 'package:laurum/features/orders/pages/antrean_data.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final variant in [
    'normal',
    'proses',
    'kosong',
    'filter_kosong',
    'loading',
    'error',
    'whatsapp',
  ]) {
    testWidgets('antrean $variant golden', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final scope = ProviderContainer(
        overrides: [
          ...dummyRepositoryOverrides,
          if (variant.contains('kosong'))
            antreanDataProvider.overrideWithValue(const AsyncData(AntreanData([], [], {}, {}, []))),
          if (variant == 'loading') antreanDataProvider.overrideWithValue(const AsyncLoading()),
          if (variant == 'error')
            antreanDataProvider.overrideWithValue(AsyncError(Exception('test'), StackTrace.empty)),
        ],
      );
      if (variant == 'proses' || variant == 'filter_kosong') {
        scope.read(antreanFilterProvider.notifier).select(2);
      }
      if (variant == 'whatsapp') {
        scope.read(whatsappConnectionProvider.notifier).setConnected(connected: false);
      }
      await pumpAntrean(tester, container: scope);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('antrean-golden')),
        matchesGoldenFile('goldens/antrean_$variant.png'),
      );
    });
  }
}
