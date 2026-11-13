import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

import 'antrean_test_host.dart';
import 'r9_checkout_host.dart';

class SlowReceiptPrinter extends FakePrintService {
  final link = Completer<void>();
  @override
  Future<bool> connect(PrinterDevice device) async {
    await link.future;
    return super.connect(device);
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('receipt refresh spins, reports connection, never prints or completes the order', (
    tester,
  ) async {
    final printer = SlowReceiptPrinter()
      ..connectedPrinter = const PrinterDevice(id: 'printer', name: 'Thermal 58');
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        printServiceProvider.overrideWithValue(printer),
      ],
    );
    final detail = await r9Checkout(scope);
    final original = detail.order;
    await pumpAntrean(
      tester,
      container: scope,
      location: '/transaksi/nota/${original.id}?complete=1',
    );
    await tester.tap(find.byTooltip('Refresh printer'));
    await tester.pump();
    expect(find.byType(AppLoader), findsOneWidget);
    expect(printer.printedReceipts, isEmpty);
    printer.link.complete();
    await tester.pumpAndSettle();
    expect(find.byType(AppLoader), findsNothing);
    expect(find.text('Printer berhasil terhubung kembali.'), findsOneWidget);
    final banner = tester.widget<BannerMessage>(find.byType(BannerMessage).last);
    expect(banner.variant, BannerMessageVariant.success);
    expect(printer.printedReceipts, isEmpty);
    expect(
      (await scope.read(orderRepositoryProvider).getOrderById(original.id))!.status,
      original.status,
    );
  });
}
