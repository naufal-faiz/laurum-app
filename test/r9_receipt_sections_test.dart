import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/features/reports/state/outstanding_data.dart';
import 'package:laurum/features/reports/widgets/outstanding_list_section.dart';
import 'package:laurum/features/transactions/state/receipt_document.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/features/transactions/widgets/receipt_links_section.dart';
import 'package:laurum/features/transactions/widgets/receipt_status_section.dart';
import 'package:laurum/shared/widgets/organisms/receipt_document.dart';

import 'r9_checkout_host.dart';
import 'r9_section_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('receipt status maps COD and delegates printer settings', (tester) async {
    final scope = r9Scope();
    addTearDown(scope.dispose);
    final data = await r9Checkout(scope);
    final view = (await scope.read(receiptViewProvider(data.order.id).future))!;
    var settings = false;
    await pumpR9Section(
      tester,
      Column(
        children: [
          ReceiptStatusSection(
            view: view,
            printState: (printing: false, error: 'Printer gagal', notice: null),
            printerStatus: PrintStatus.disconnected,
            printerName: null,
            onRetry: () {},
            onSettings: () => settings = true,
          ),
          ReceiptDocument(data: receiptDocument(view)),
        ],
      ),
    );
    expect(find.text('COD - sisa Rp25.000'), findsOneWidget);
    await tester.tap(find.byTooltip('Pengaturan printer'));
    expect(settings, isTrue);
  });
  testWidgets('receipt actions expose recording only while available', (tester) async {
    var recorded = false;
    await pumpR9Section(
      tester,
      ReceiptLinksSection(
        busy: false,
        onOrder: () {},
        onRecord: () => recorded = true,
      ),
    );
    await tester.tap(find.text('Catat pembayaran'));
    expect(recorded, isTrue);
    await pumpR9Section(
      tester,
      ReceiptLinksSection(
        busy: false,
        onOrder: () {},
      ),
    );
    expect(find.text('Catat pembayaran'), findsNothing);
  });
  testWidgets('outstanding section shows COD filter and delegates record action', (tester) async {
    final scope = r9Scope();
    addTearDown(scope.dispose);
    final order = await r9Checkout(scope);
    final data = await scope.read(outstandingListProvider.future);
    String? paid;
    await pumpR9Section(
      tester,
      OutstandingListSection(
        data: data,
        filter: 1,
        now: DateTime(2026, 10, 16),
        onFilter: (_) {},
        onPay: (row) => paid = row.order.id,
      ),
    );
    expect(find.text('COD 1'), findsOneWidget);
    expect(find.text('Ingatkan'), findsNothing);
    await tester.tap(find.text('Catat bayar'));
    expect(paid, order.order.id);
  });
}
