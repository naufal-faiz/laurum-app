import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

import 'antrean_test_host.dart';

class PendingDiscoveryPrinter extends FakePrintService {
  final scan = Completer<void>();
  final link = Completer<void>();
  int scans = 0, links = 0;
  @override
  Future<List<PrinterDevice>> discover() async {
    scans++;
    await scan.future;
    return super.discover();
  }

  @override
  Future<bool> connect(PrinterDevice device) async {
    links++;
    await link.future;
    return super.connect(device);
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('search modal shows saved printer while scanning and blocks duplicate work', (
    tester,
  ) async {
    final service = PendingDiscoveryPrinter()
      ..connectedPrinter = const PrinterDevice(id: 'saved', name: 'Printer rumah')
      ..status = PrintStatus.connected;
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        printServiceProvider.overrideWithValue(service),
      ],
    );
    final settings = scope.read(localSettingsRepositoryProvider);
    await settings.setString('printer_id', 'saved');
    await settings.setString('printer_name', 'Printer rumah');
    await pumpAntrean(tester, container: scope, location: '/lainnya/printer');
    await tester.tap(find.text('Ganti'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Mencari printer...'), findsOneWidget);
    expect(find.byType(AppLoader), findsOneWidget);
    expect(find.text('Printer tersimpan di perangkat'), findsOneWidget);
    final saved = tester.widget<MenuRow>(
      find.byWidgetPredicate((w) => w is MenuRow && w.label == 'Printer rumah'),
    );
    expect(saved.onTap, isNull);
    await scope.read(printerConnectionProvider.notifier).discover();
    expect(service.scans, 1);
    service.scan.complete();
    await tester.pumpAndSettle();
    expect(find.text('Printer terdeteksi'), findsOneWidget);
    await tester.tap(find.widgetWithText(MenuRow, 'Printer rumah'));
    await tester.pump();
    expect(find.text('Menghubungkan printer...'), findsOneWidget);
    await scope
        .read(printerConnectionProvider.notifier)
        .connect(const PrinterDevice(id: 'saved', name: 'Printer rumah'));
    expect(service.links, 1);
    service.link.complete();
    await tester.pumpAndSettle();
    expect(find.text('Terhubung ke Printer rumah.'), findsOneWidget);
    expect(service.printedReceipts, isEmpty);
    expect(await settings.getString('printer_id'), 'saved');
  });
}
