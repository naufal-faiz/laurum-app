import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/shared/widgets/organisms/nota_card.dart';
import 'package:laurum/shared/widgets/organisms/order_card.dart';
import 'package:laurum/shared/widgets/organisms/piutang_card.dart';

import 'r9_section_host.dart';

void main() {
  testWidgets('cards accept COD label; ready action asks for payment; reminder may be absent', (
    tester,
  ) async {
    var advanced = 0, paid = 0;
    await pumpR9Section(
      tester,
      Column(
        children: [
          OrderCard(
            orderNo: 'A-9000',
            customerName: 'Dedi',
            summary: 'Cucian',
            total: 25000,
            status: OrderStatus.siap,
            payStatus: PayStatus.belumBayar,
            paymentLabel: 'COD - sisa Rp25.000',
            onAction: () => advanced++,
          ),
          const NotaCard(
            orderNo: 'A-9000',
            customerName: 'Dedi',
            summary: 'Cucian',
            total: 25000,
            status: OrderStatus.siap,
            payStatus: PayStatus.belumBayar,
            paymentLabel: 'COD - sisa Rp25.000',
          ),
          PiutangCard(
            orderNo: 'A-9000',
            customerName: 'Dedi',
            summary: 'Cucian',
            total: 25000,
            paid: 0,
            ageLabel: 'hari ini',
            paymentLabel: 'COD - sisa Rp25.000',
            onPay: () => paid++,
          ),
        ],
      ),
    );
    expect(find.text('COD - sisa Rp25.000'), findsNWidgets(3));
    expect(find.text('Ingatkan'), findsNothing);
    await tester.tap(find.text('Terima pembayaran'));
    expect(advanced, 1);
    await tester.ensureVisible(find.text('Catat bayar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Catat bayar'));
    expect(paid, 1);
  });
}
