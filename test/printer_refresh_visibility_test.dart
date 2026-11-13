import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/printer/state/printer_settings.dart';
import 'package:laurum/features/printer/widgets/printer_connection_section.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

final printerDataChanged = Provider<Object>((ref) => Object());

class DeferredPrinterSettings extends PrinterSettingsController {
  DeferredPrinterSettings(this.load);
  final Future<PrinterSettingsState> Function() load;
  @override
  Future<PrinterSettingsState> build() {
    ref.watch(printerDataChanged);
    return load();
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('settings reload preserves the mounted printer controls', (tester) async {
    final fixture = ProviderContainer(overrides: dummyRepositoryOverrides);
    final initial = await fixture.read(printerSettingsProvider.future);
    fixture.dispose();
    Future<PrinterSettingsState> result = Future.value(initial);
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        printerSettingsProvider.overrideWith(() => DeferredPrinterSettings(() => result)),
      ],
    );
    await pumpAntrean(tester, location: '/lainnya/printer', container: scope);
    final controls = tester.element(find.byType(PrinterConnectionSection));
    final pending = Completer<PrinterSettingsState>();
    result = pending.future;
    scope.invalidate(printerDataChanged);
    await tester.pump();
    expect(find.text('Cari printer'), findsOneWidget);
    expect(tester.element(find.byType(PrinterConnectionSection)), same(controls));
    pending.complete(initial);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
