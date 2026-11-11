import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/receipt_pdf.dart';
import 'package:laurum/features/transactions/state/receipt_document.dart';
import 'package:laurum/features/transactions/state/receipt_download.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/main_dummy.dart';

import 'r9_checkout_host.dart';
import 'receipt_download_fake.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final result in [true, false, null]) {
    test('download result=$result distinguishes saved, cancelled and failed', () async {
      final service = FakeReceiptDownload()..result = result;
      final scope = ProviderContainer(
        overrides: [
          ...dummyRepositoryOverrides,
          receiptDownloadServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(scope.dispose);
      scope.listen(receiptDownloadProvider, (_, _) {});
      final data = await r9Checkout(scope);
      final view = (await scope.read(receiptViewProvider(data.order.id).future))!;
      final lines = view.lines;
      await scope.read(receiptDownloadProvider.notifier).save(view);
      final state = scope.read(receiptDownloadProvider);
      expect(state.busy, isFalse);
      expect(state.notice, result == true ? 'PDF struk tersimpan.' : null);
      expect(state.error, result == null ? 'Struk gagal diunduh. Silakan coba lagi.' : null);
      expect(service.captured!.fileName, 'struk-${view.order.orderNo}');
      expect(view.lines, lines);
      expect(service.captured!.status, contains('COD'));
    });
  }
  test('download blocks duplicates until the save dialog completes', () async {
    final service = FakeReceiptDownload()..pending = Completer<bool>();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        receiptDownloadServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(scope.dispose);
    scope.listen(receiptDownloadProvider, (_, _) {});
    final data = await r9Checkout(scope);
    final view = (await scope.read(receiptViewProvider(data.order.id).future))!;
    final pending = scope.read(receiptDownloadProvider.notifier).save(view);
    expect(scope.read(receiptDownloadProvider).busy, isTrue);
    await scope.read(receiptDownloadProvider.notifier).save(view);
    expect(service.calls, 1);
    service.pending!.complete(false);
    await pending;
    expect(scope.read(receiptDownloadProvider).busy, isFalse);
  });
  test('PDF contains a complete document from the same settled invoice data', () async {
    final scope = r9Scope();
    addTearDown(scope.dispose);
    final data = await r9Checkout(scope, term: PayTerm.sekarang, received: 25000);
    final view = (await scope.read(receiptViewProvider(data.order.id).future))!;
    final document = receiptDocument(view);
    expect(document.settled, isTrue);
    expect(document.groups.last.singleWhere((r) => r.label == 'TOTAL').value, 'Rp25.000');
    final bytes = await receiptPdf(document);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(String.fromCharCodes(bytes.skip(bytes.length - 16)), contains('%%EOF'));
    expect(bytes.length, greaterThan(1000));
  });
}
