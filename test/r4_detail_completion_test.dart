import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/widgets/order_detail_body_section.dart';
import 'package:laurum/features/orders/widgets/order_detail_content_section.dart';
import 'package:laurum/features/orders/widgets/order_detail_footer_section.dart';
import 'package:laurum/features/orders/widgets/order_summary_section.dart';

import 'antrean_test_host.dart';
import 'r4_completion_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('simplified Detail sections edit, print then finish unpaid order', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final printer = CompletionPrinter();
    final scope = await completionScope(printer);
    await pumpAntrean(tester, container: scope, location: '/order/ord-0142');
    expect(find.byType(OrderDetailContentSection), findsOneWidget);
    expect(find.byType(OrderDetailBodySection), findsOneWidget);
    expect(find.byType(OrderSummarySection), findsOneWidget);
    expect(find.byType(OrderDetailFooterSection), findsOneWidget);
    expect(find.text('Sedang dikerjakan'), findsOneWidget);
    expect(find.byTooltip('Menu order'), findsNothing);
    expect(find.text('Cetak struk'), findsNothing);
    expect(find.text('Tandai siap'), findsNothing);
    expect(find.text('Hapus'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/r4_order_detail.png'),
    );
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Simpan perubahan'), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar tanpa simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selesaikan'));
    await tester.pumpAndSettle();
    expect(find.text('Cetak dan selesaikan?'), findsOneWidget);
    expect(printer.calls, 0);
    await tester.tap(find.text('Cetak struk'));
    await tester.pumpAndSettle();
    expect(printer.calls, 1);
    expect(find.text('Selesai'), findsOneWidget);
    expect(find.text('Cetak struk'), findsOneWidget);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Selesaikan'), findsNothing);
    expect(find.text('Hapus'), findsNothing);
    final order = (await scope.read(orderRepositoryProvider).getOrderById('ord-0142'))!;
    expect(order.status, OrderStatus.selesai);
    expect(
      (await scope.read(antreanDataProvider.future)).orders.map((o) => o.id),
      isNot(contains(order.id)),
    );
    expect(await scope.read(orderRepositoryProvider).getPaymentsByOrderId(order.id), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Hapus uses cancellation; final order only offers printing', (tester) async {
    final scope = await completionScope(CompletionPrinter());
    await pumpAntrean(tester, container: scope, location: '/order/ord-0142');
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus nota ini?'), findsOneWidget);
    await tester.tap(find.text('Ya, hapus nota'));
    await tester.pumpAndSettle();
    expect(
      (await scope.read(orderRepositoryProvider).getOrderById('ord-0142'))!.status,
      OrderStatus.dibatalkan,
    );
    expect(find.text('Cetak struk'), findsOneWidget);
    expect(find.text('Selesaikan'), findsNothing);
    expect(find.text('Hapus'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
