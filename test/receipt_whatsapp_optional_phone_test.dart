import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/services/external_launcher.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/transactions/state/receipt_document.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

import 'receipt_fixtures.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  final view = ReceiptView(
    order: receiptOrder(),
    items: receiptItems,
    payments: receiptPayments(),
    customer: Customer(
      id: 'customer',
      ownerId: receiptOwner,
      createdAt: receiptAt,
      name: 'Pelanggan',
    ),
    business: receiptBusiness(),
    settings: receiptSettings(),
    savingsBalance: 0,
  );

  test('empty phone is a dash in receipt and shares an image without a recipient', () async {
    final launcher = FakeExternalLauncher();
    final scope = ProviderContainer(
      overrides: [externalLauncherProvider.overrideWithValue(launcher)],
    );
    addTearDown(scope.dispose);
    expect(view.lines, contains('No. HP  : -'));
    final document = receiptDocument(view);
    expect(document.groups.first.singleWhere((row) => row.label == 'No. HP').value, '-');
    await scope.read(receiptPrintProvider.notifier).sendWhatsApp(view);
    expect(launcher.whatsAppCalls.single.phone, '');
    expect(launcher.whatsAppCalls.single.message, contains(view.order.orderNo));
    expect(launcher.whatsAppReceipts.single!.groups.first.last.value, '-');
    expect(scope.read(receiptPrintProvider).error, isNull);
    launcher.shouldSucceed = false;
    await scope.read(receiptPrintProvider.notifier).sendWhatsApp(view);
    expect(scope.read(receiptPrintProvider).error, 'Gagal membuka WhatsApp.');
    expect(scope.read(receiptPrintProvider).notice, isNull);
  });
}
