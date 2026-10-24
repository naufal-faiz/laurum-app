import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/organisms/nota_card.dart';

import '../widgetbook/organisms/nota_card_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('NotaCard renders DP and opens history without progress actions', (tester) async {
    var opens = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: NotaCard(
            orderNo: 'A-0140',
            customerName: 'Bu Sari',
            summary: 'Cuci kiloan',
            total: 25000,
            paid: 10000,
            status: OrderStatus.menungguJemput,
            payStatus: PayStatus.dp,
            onTap: () => opens++,
          ),
        ),
      ),
    );
    expect(find.text('DP Rp10.000'), findsOneWidget);
    expect(find.text('Menunggu jemput'), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
    await tester.tap(find.text('A-0140'));
    expect(opens, 1);
  });
  registerOrganismGallery('nota_card', notaCardUseCase.builder, height: 1100);
}
