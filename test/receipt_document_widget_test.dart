import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/features/transactions/state/receipt_document.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/features/transactions/widgets/receipt_content_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/receipt_rows.dart';
import 'package:laurum/shared/widgets/organisms/receipt_document.dart';

import 'r9_checkout_host.dart';
import 'r9_section_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final kind in ['rows', 'document', 'content']) {
    testWidgets('receipt $kind preserves invoice totals and actions', (tester) async {
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final scope = r9Scope();
      addTearDown(scope.dispose);
      final order = await r9Checkout(
        scope,
        term: kind == 'document' ? PayTerm.sekarang : PayTerm.cod,
        received: kind == 'document' ? 25000 : null,
      );
      final view = (await scope.read(receiptViewProvider(order.order.id).future))!;
      final document = receiptDocument(view);
      var detail = false, payment = false, settings = false;
      await pumpR9Section(tester, switch (kind) {
        'rows' => ReceiptRows(rows: document.groups.last),
        'document' => ReceiptDocument(data: document),
        _ => ReceiptContentSection(
          view: view,
          printState: (printing: false, error: 'Printer gagal', notice: null),
          download: (busy: false, error: null, notice: null),
          printerStatus: PrintStatus.disconnected,
          printerName: null,
          onRetry: () {},
          onSettings: () => settings = true,
          onOrder: () => detail = true,
          onRecord: () => payment = true,
        ),
      });
      expect(find.text('TOTAL'), findsOneWidget);
      expect(find.text('Rp25.000'), findsWidgets);
      expect(tester.takeException(), isNull);
      if (kind != 'rows' && view.customer.address.trim().isNotEmpty) {
        final address = find.text(view.customer.address.trim());
        expect(address, findsOneWidget);
        expect(
          tester
              .widget<AppText>(find.ancestor(of: address, matching: find.byType(AppText)))
              .maxLines,
          2,
        );
      }
      if (kind == 'rows') {
        expect(
          tester.getRect(find.text('Rp25.000').first).right,
          tester.getRect(find.byType(ReceiptRows)).right,
        );
      }
      if (kind == 'content') {
        for (final label in ['Lihat detail', 'Catat pembayaran', 'Pengaturan printer']) {
          final target = label == 'Pengaturan printer' ? find.byTooltip(label) : find.text(label);
          await tester.ensureVisible(target);
          await tester.tap(target);
        }
        expect([detail, payment, settings], [true, true, true]);
      }
      if (kind == 'document') {
        expect(find.text(view.customer.name), findsOneWidget);
        final status = find.ancestor(
          of: find.text(document.status),
          matching: find.byType(AppText),
        );
        expect(tester.widget<AppText>(status).variant, AppTextVariant.label);
        expect(tester.getRect(find.text('Tunai')).right, greaterThan(tester.getRect(status).right));
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/receipt_document.png'),
        );
      }
    });
  }
}
