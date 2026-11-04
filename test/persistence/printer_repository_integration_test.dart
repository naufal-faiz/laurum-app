import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/features/printer/state/printer_settings.dart';
import 'package:laurum/features/settings/state/order_status_setting.dart';

import 'b1c_harness.dart';

void main() {
  late B1cHarness h;
  late ProviderContainer scope;
  setUp(() {
    h = B1cHarness();
    scope = ProviderContainer(
      overrides: [
        businessRepositoryProvider.overrideWithValue(h.business),
        receiptSettingsRepositoryProvider.overrideWithValue(h.receipts),
        transactionRunnerProvider.overrideWithValue(h.writer.runner),
        localSettingsRepositoryProvider.overrideWithValue(DriftLocalSettingsRepository(h.db)),
        printServiceProvider.overrideWithValue(FakePrintService()),
      ],
    );
  });
  tearDown(() async {
    scope.dispose();
    await h.db.close();
  });
  test('printer save rolls back settings when the profile write fails, then retries', () async {
    await h.business.saveProfile(h.profile());
    await scope.read(printerSettingsProvider.future);
    final controller = scope.read(printerSettingsProvider.notifier);
    controller.edit(paperMm: 80, footer: 'Footer baru');
    await h.db.customStatement('''CREATE TRIGGER fail_business BEFORE UPDATE ON businesses
      BEGIN SELECT RAISE(ABORT, 'injected'); END''');
    await expectLater(controller.save(), throwsA(anything));
    expect(await h.db.select(h.db.receiptSettingRecords).get(), isEmpty);
    expect((await h.business.getProfile()).receiptFooter, isEmpty);
    expect(await h.db.select(h.db.outboxRecords).get(), hasLength(1));
    expect(scope.read(printerSettingsProvider).value!.notice, isNull);
    await h.db.customStatement('DROP TRIGGER fail_business');
    await controller.save();
    expect((await h.receipts.getReceiptSettings()).paperMm, 80);
    expect((await h.business.getProfile()).receiptFooter, 'Footer baru');
    expect(await h.db.select(h.db.outboxRecords).get(), hasLength(3));
    expect(scope.read(printerSettingsProvider).value!.notice, 'Pengaturan struk disimpan.');
  });
  test('printer save preserves status mode changed after opening the form', () async {
    await h.business.saveProfile(h.profile());
    await scope.read(printerSettingsProvider.future);
    scope.read(printerSettingsProvider.notifier).edit(note: 'Catatan baru');
    expect(
      await scope.read(orderStatusSettingProvider.notifier).setEnabled(enabled: false),
      isTrue,
    );
    await scope.read(printerSettingsProvider.notifier).save();
    expect((await h.business.getProfile()).useOrderStatus, isFalse);
    expect((await h.business.getProfile()).receiptNote, 'Catatan baru');
    expect((await h.receipts.getReceiptSettings()).paperMm, 58);
  });
  test('device printer persists locally without creating an outbox entry', () async {
    final connection = scope.read(printerConnectionProvider.notifier);
    const device = PrinterDevice(id: 'device-1', name: 'Printer HP ini');
    expect(await connection.connect(device), isTrue);
    final reread = DriftLocalSettingsRepository(h.db);
    expect(await reread.getString('printer_id'), device.id);
    expect(await reread.getString('printer_name'), device.name);
    expect(await h.db.select(h.db.outboxRecords).get(), isEmpty);
    expect(await h.db.select(h.db.receiptSettingRecords).get(), isEmpty);
  });
}
