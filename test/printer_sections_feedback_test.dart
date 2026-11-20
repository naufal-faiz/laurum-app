import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/features/printer/state/printer_settings.dart';
import 'package:laurum/features/printer/state/printer_state.dart';
import 'package:laurum/features/printer/widgets/printer_connection_section.dart';
import 'package:laurum/features/printer/widgets/printer_settings_section.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

import 'r9_section_host.dart';

void main() {
  testWidgets('connection section signals success, warning and failure', (tester) async {
    var searches = 0;
    for (final (status, failed, variant) in [
      (PrintStatus.connected, false, BannerMessageVariant.success),
      (PrintStatus.bluetoothOff, true, BannerMessageVariant.warning),
      (PrintStatus.error, true, BannerMessageVariant.error),
    ]) {
      await pumpR9Section(
        tester,
        PrinterConnectionSection(
          printer: PrinterConnectionState(
            status: status,
            notice: 'Hasil koneksi',
            noticeError: failed,
          ),
          onFind: () => searches++,
        ),
      );
      expect(tester.widget<BannerMessage>(find.byType(BannerMessage).first).variant, variant);
      await tester.tap(find.text('Cari printer'));
    }
    expect(searches, 3);
  });
  testWidgets('settings section reports success and delegates edits and information', (
    tester,
  ) async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final settings = await scope.read(printerSettingsProvider.future);
    int? font;
    String? notice;
    await pumpR9Section(
      tester,
      PrinterSettingsSection(
        printer: settings.copyWith(notice: 'Pengaturan struk disimpan.', noticeSuccess: true),
        onEdit: ({
          paperMm,
          fontSize,
          showAddress,
          showCustomer,
          showSavings,
          showNote,
          footer,
          note,
        }) => font = fontSize,
        onNotice: (message) => notice = message,
      ),
    );
    expect(
      tester.widget<BannerMessage>(find.byType(BannerMessage)).variant,
      BannerMessageVariant.success,
    );
    await tester.tap(find.text('Besar'));
    expect(font, 13);
    await tester.tap(find.text('80 mm'));
    expect(notice, contains('coming soon'));
  });
}
