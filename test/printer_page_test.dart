import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  Future<({ProviderContainer container, FakePrintService service})> pumpPrinter(
    WidgetTester tester, {
    FakePrintService? service,
  }) async {
    final printer = service ?? FakePrintService();
    final scope = ProviderContainer(
      overrides: [...dummyRepositoryOverrides, printServiceProvider.overrideWithValue(printer)],
    );
    final host = await pumpAntrean(tester, container: scope, location: '/lainnya/printer');
    return (container: host.container, service: printer);
  }

  testWidgets('printer page connects, changes paper and saves settings', (tester) async {
    final host = await pumpPrinter(tester);
    expect(find.text('Printer belum terhubung.'), findsOneWidget);
    await tester.tap(find.text('Cari printer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Thermal 58mm'));
    await tester.pumpAndSettle();
    expect(find.text('Terhubung dan siap mencetak'), findsOneWidget);
    await tester.tap(find.text('80 mm'));
    await tester.pumpAndSettle();
    expect(find.text('Thermal 80 mm'), findsOneWidget);

    await tester.ensureVisible(find.byType(AppSwitch).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppSwitch).first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Jl. Melati'), findsNothing);
    await tester.tap(find.text('Simpan pengaturan'));
    await tester.pumpAndSettle();
    final settings = await host.container.read(businessRepositoryProvider).getReceiptSettings();
    expect(settings.showAddress, isFalse);
    expect(settings.paperMm, 80);

    await tester.tap(find.text('Cetak uji'));
    await tester.pumpAndSettle();
    expect(host.service.printedReceipts, hasLength(1));
    expect(host.service.printedReceipts.single.paperMm, 80);
    expect(find.text('Struk uji terkirim ke printer.'), findsOneWidget);
  });

  testWidgets('failed print shows an error banner', (tester) async {
    final host = await pumpPrinter(tester);
    await tester.tap(find.text('Cari printer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Thermal 58mm'));
    await tester.pumpAndSettle();
    host.service.printSucceeds = false;
    await tester.tap(find.text('Cetak uji'));
    await tester.pumpAndSettle();
    expect(find.text('Cetak gagal. Periksa printer.'), findsOneWidget);
  });

  testWidgets('bluetooth off opens the enable sheet before discovery', (tester) async {
    final host = await pumpPrinter(tester, service: FakePrintService(bluetoothOn: false));
    await tester.tap(find.text('Cari printer'));
    await tester.pumpAndSettle();
    expect(find.text('Aktifkan Bluetooth'), findsWidgets);
    await tester.tap(find.text('Aktifkan Bluetooth').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cari printer'));
    await tester.pumpAndSettle();
    expect(find.text('Thermal 58mm'), findsOneWidget);
    expect(host.service.printedReceipts, isEmpty);
  });

  testWidgets('printer page golden', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final host = await pumpPrinter(tester);
    await tester.tap(find.text('Cari printer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Thermal 58mm'));
    await tester.pumpAndSettle();
    expect(host.service.status, PrintStatus.connected);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/printer_page.png'),
    );
  });
}
