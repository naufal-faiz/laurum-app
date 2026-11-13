import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/organisms/order_card.dart';

void main() {
  for (final width in [280.0, 320.0, 390.0]) {
    for (final showAction in [false, true]) {
      testWidgets('long COD label keeps the price at bottom right: $width, action=$showAction', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: width,
                  child: OrderCard(
                    orderNo: 'A-0001',
                    customerName: 'Pelanggan',
                    summary: 'Cuci setrika',
                    total: 70000,
                    status: OrderStatus.siap,
                    payStatus: PayStatus.belumBayar,
                    paymentLabel: 'COD - Sisa Rp70.000',
                    detail: 'Pengambilan di toko',
                    showAction: showAction,
                    onAction: () {},
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final price = tester.getRect(find.text('Rp70.000'));
        final card = tester.getRect(find.byType(AppCard));
        final label = tester.getRect(find.text('COD - Sisa Rp70.000'));
        expect(price.right, closeTo(card.right - AppSpacing.cardPadding, 0.01));
        expect(price.top, greaterThanOrEqualTo(label.bottom));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
