import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/transactions/state/receipt_download.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';

import 'antrean_test_host.dart';
import 'r9_checkout_host.dart';
import 'receipt_download_fake.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('download disables four actions, saves without completing COD and returns home', (
    tester,
  ) async {
    final saver = FakeReceiptDownload()..pending = Completer<bool>();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        receiptDownloadServiceProvider.overrideWithValue(saver),
      ],
    );
    final data = await r9Checkout(scope);
    final host = await pumpAntrean(
      tester,
      container: scope,
      location: '/transaksi/nota/${data.order.id}',
    );
    await tester.tap(find.byTooltip('Unduh'));
    await tester.pump();
    expect(saver.calls, 1);
    expect(scope.read(receiptDownloadProvider).busy, isTrue);
    expect(tester.widget<AppButton>(find.widgetWithText(AppButton, 'Selesai')).onPressed, isNull);
    for (final button in tester.widgetList<AppIconButton>(find.byType(AppIconButton))) {
      if (['WhatsApp', 'Unduh', 'Cetak struk'].contains(button.label)) {
        expect(button.onPressed, isNull);
      }
    }
    saver.pending!.complete(true);
    await tester.pumpAndSettle();
    expect(scope.read(receiptDownloadProvider).notice, 'PDF struk tersimpan.');
    final orders = scope.read(orderRepositoryProvider);
    expect((await orders.getOrderById(data.order.id))!.status, data.order.status);
    expect(await orders.getPaymentsByOrderId(data.order.id), data.payments);
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(host.router.routeInformationProvider.value.uri.path, '/antrean');
    expect((await orders.getOrderById(data.order.id))!.status, data.order.status);
  });
}
