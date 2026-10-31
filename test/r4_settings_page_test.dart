import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/business/data/in_memory_business_repository.dart';
import 'package:laurum/features/settings/widgets/settings_menu_section.dart';
import 'package:laurum/features/settings/widgets/settings_operational_section.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

import 'antrean_test_host.dart';
import 'r4_finish_test_host.dart';
import 'r4_settings_test_support.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets(
    'settings toggle disabled during save, failure keeps value, retry updates cached queue',
    (tester) async {
      final control = BusinessSaveControl()..gate = Completer<void>();
      final business = ControlledBusiness(control);
      final scope = ProviderContainer(
        overrides: [
          ...dummyRepositoryOverrides,
          inMemoryBusinessRepositoryProvider.overrideWith(() => business),
        ],
      );
      final host = await pumpAntrean(tester, container: scope);
      host.router.go('/lainnya');
      await tester.pumpAndSettle();
      expect(find.byType(SettingsMenuSection), findsOneWidget);
      expect(find.byType(SettingsOperationalSection), findsOneWidget);
      expect(tester.widget<ToggleRow>(find.byType(ToggleRow)).value, isTrue);
      await tapStatusSwitch(tester);
      expect(tester.widget<ToggleRow>(find.byType(ToggleRow)).onChanged, isNull);
      control.fail = true;
      control.gate!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Gagal menyimpan pengaturan. Coba ubah sakelar lagi.'), findsOneWidget);
      expect(tester.widget<ToggleRow>(find.byType(ToggleRow)).value, isTrue);
      control.fail = false;
      await tapStatusSwitch(tester);
      expect(tester.widget<ToggleRow>(find.byType(ToggleRow)).value, isFalse);
      host.router.go('/antrean');
      await tester.pumpAndSettle();
      expect(tester.widget<ChipBar>(find.byType(ChipBar)).labels, ['Semua 12', 'Perlu dicek 3']);
      host.router.go('/lainnya');
      await tester.pumpAndSettle();
      await tapStatusSwitch(tester);
      expect((await scope.read(businessRepositoryProvider).getProfile()).useOrderStatus, isTrue);
      host.router.go('/antrean');
      await tester.pumpAndSettle();
      expect(tester.widget<ChipBar>(find.byType(ChipBar)).labels.length, 5);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('settings R4 toggle golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/lainnya');
    await tapStatusSwitch(tester);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/r4_settings.png'),
    );
  });

  testWidgets('settings toggle fits 320px with 2x text', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/lainnya', textScale: 2);
    await tester.ensureVisible(find.byType(ToggleRow));
    await tester.pumpAndSettle();
    expect(find.text('Pakai status order'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
