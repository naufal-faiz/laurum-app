import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/transactions/widgets/receipt_actions_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'r9_section_host.dart';

void main() {
  for (final cod in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('receipt actions COD=$cod scale=$scale stay compact and readable', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(320, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final calls = <String>[];
        await pumpR9Section(
          tester,
          MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: ReceiptActionsSection(
              busy: false,
              onPrint: () => calls.add('print'),
              onWhatsApp: () => calls.add('wa'),
              onHome: () => calls.add('home'),
              onOrder: () => calls.add('order'),
              onRecord: cod ? () => calls.add('pay') : null,
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Transaksi baru'), findsNothing);
        expect(find.text('Cetak struk'), findsNothing);
        final rows = find.descendant(
          of: find.byType(ReceiptActionsSection),
          matching: find.byType(Row),
        );
        final wa = tester.getRect(find.widgetWithText(AppButton, 'WhatsApp'));
        final print = tester.getRect(find.byTooltip('Cetak struk'));
        final home = tester.getRect(find.widgetWithText(AppButton, 'Ke beranda'));
        final detail = tester.getRect(find.widgetWithText(AppButton, 'Lihat detail'));
        expect(rows, findsWidgets);
        expect(wa.center.dy, print.center.dy);
        expect(home.center.dy, scale == 1 ? detail.center.dy : greaterThan(detail.bottom));
        expect(wa.width, greaterThan(print.width));
        expect(detail.width, scale == 1 ? greaterThan(home.width) : home.width);
        expect(home.top, greaterThanOrEqualTo(wa.bottom));
        expect(tester.getSize(find.text('WhatsApp')).height, lessThan(100));
        if (cod && scale == 2) {
          final pay = tester.getRect(find.widgetWithText(AppButton, 'Catat pembayaran'));
          expect(pay.bottom, lessThan(wa.top));
          expect(pay.width, greaterThan(wa.width));
        }
        for (final target in [
          find.text('WhatsApp'),
          find.byTooltip('Cetak struk'),
          find.text('Ke beranda'),
          find.text('Lihat detail'),
          if (cod) find.text('Catat pembayaran'),
        ]) {
          await tester.tap(target);
        }
        expect(calls, ['wa', 'print', 'home', 'order', if (cod) 'pay']);
      });
    }
  }
}
