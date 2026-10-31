import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/organisms/order_card.dart';

import '../widgetbook/organisms/order_card_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('OrderCard prioritizes cancellation rail and delegates action', (tester) async {
    var calls = 0, opens = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: OrderCard(
            orderNo: 'A-0142',
            customerName: 'Pak Dedi',
            summary: 'Cuci kiloan',
            total: 31500,
            status: OrderStatus.diproses,
            payStatus: PayStatus.belumBayar,
            needsReview: true,
            cancelRequested: true,
            onAction: () => calls++,
            onTap: () => opens++,
          ),
        ),
      ),
    );
    expect(tester.widget<AppCard>(find.byType(AppCard)).rail, AppCardRail.error);
    expect(find.text('Diproses'), findsOneWidget);
    await tester.tap(find.text('Tandai siap'));
    expect(calls, 1);
    expect(opens, 0);
  });
  testWidgets('showAction false hides progress while keeping card openable', (tester) async {
    var opens = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: OrderCard(
            orderNo: 'A-0142',
            customerName: 'Pak Dedi',
            summary: 'Cuci kiloan',
            total: 31500,
            status: OrderStatus.diproses,
            payStatus: PayStatus.belumBayar,
            showAction: false,
            onTap: () => opens++,
          ),
        ),
      ),
    );
    expect(find.text('Tandai siap'), findsNothing);
    expect(find.text('Diproses'), findsOneWidget);
    await tester.tap(find.text('A-0142'));
    expect(opens, 1);
  });
  testWidgets('statusLabel changes badge text while preserving payment and card action', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: OrderCard(
            orderNo: 'A-0142',
            customerName: 'Pak Dedi',
            summary: 'Cuci kiloan',
            total: 31500,
            status: OrderStatus.diproses,
            payStatus: PayStatus.belumBayar,
            statusLabel: 'Sedang dikerjakan',
            showAction: false,
          ),
        ),
      ),
    );
    expect(find.text('Sedang dikerjakan'), findsOneWidget);
    expect(find.text('Diproses'), findsNothing);
    expect(find.text('Belum bayar'), findsOneWidget);
    expect(find.text('Rp31.500'), findsOneWidget);
  });
  registerOrganismGallery('order_card', orderCardUseCase.builder, height: 1500);
}
