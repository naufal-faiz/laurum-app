import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/widgets/order_customer_section.dart';
import 'package:laurum/features/orders/widgets/order_items_section.dart';
import 'package:laurum/features/orders/widgets/order_payment_section.dart';
import 'package:laurum/features/orders/widgets/order_summary_section.dart';
import 'package:laurum/features/orders/widgets/order_timeline_section.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final section in ['summary', 'customer', 'items', 'payment', 'timeline']) {
    testWidgets('order detail $section preserves stored values and callbacks', (tester) async {
      await loadTestFonts();
      final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
      addTearDown(scope.dispose);
      final data = (await scope.read(orderDetailProvider('ord-0142').future))!;
      var contacts = 0;
      var payments = 0;
      final widget = switch (section) {
        'summary' => OrderSummarySection(data: data),
        'customer' => OrderCustomerSection(data: data, onWhatsApp: () => contacts++),
        'items' => OrderItemsSection(data: data),
        'payment' => OrderPaymentSection(data: data, onRecord: () => payments++),
        _ => OrderTimelineSection(data: data),
      };
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: SingleChildScrollView(child: widget)),
        ),
      );
      if (section == 'summary') {
        expect(find.text(data.order.orderNo), findsOneWidget);
        expect(find.text(data.paymentLabel), findsOneWidget);
        expect(find.text('Diproses'), findsOneWidget);
        expect(
          find.text(
            '${Formatters.tanggal(data.order.estimatedAt)} ${Formatters.jam(data.order.estimatedAt)}',
          ),
          findsOneWidget,
        );
      } else if (section == 'customer') {
        expect(find.text(data.customer.name), findsOneWidget);
        expect(find.text(Formatters.telepon(data.customer.phone)), findsOneWidget);
        expect(find.text(data.customer.address), findsOneWidget);
        await tester.tap(find.text('Buka WhatsApp'));
        expect(contacts, 1);
      } else if (section == 'items') {
        for (final item in data.items) {
          expect(find.text(item.serviceName), findsOneWidget);
        }
        expect(find.text(Formatters.rupiah(data.order.total)), findsWidgets);
        final header = tester.widget<SectionHeader>(find.byType(SectionHeader));
        expect(header.trailing, isNotNull);
        expect(find.text('${data.items.length} layanan'), findsOneWidget);
      } else if (section == 'payment') {
        expect(find.text(data.paymentLabel), findsOneWidget);
        expect(find.text(Formatters.rupiah(data.paid)), findsOneWidget);
        expect(find.text(Formatters.rupiah(data.outstanding)), findsOneWidget);
        await tester.tap(find.text('Catat pembayaran'));
        expect(payments, 1);
      } else {
        for (final activity in data.activity) {
          expect(find.text(activity.label), findsOneWidget);
          expect(find.text(Formatters.jam(activity.at)), findsWidgets);
        }
      }
      expect(tester.takeException(), isNull);
    });
  }
}
