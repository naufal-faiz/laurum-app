import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/transactions/widgets/receipt_actions_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

import 'r9_section_host.dart';

void main() {
  for (final cod in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('receipt actions COD=$cod scale=$scale stay compact and readable', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
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
        expect(find.bySemanticsLabel('Cetak struk'), findsOneWidget);
        final wa = tester.getRect(find.widgetWithText(AppButton, 'WhatsApp'));
        final printFrame = find.byTooltip('Cetak struk');
        final print = tester.getRect(printFrame);
        final home = tester.getRect(find.widgetWithText(AppButton, 'Ke beranda'));
        final detail = tester.getRect(find.widgetWithText(AppButton, 'Lihat detail'));
        expect(print.size, wa.size);
        expect(home.size, wa.size);
        expect(detail.size, wa.size);
        final printButton = tester.widget<TextButton>(
          find.descendant(of: printFrame, matching: find.byType(TextButton)),
        );
        expect(printButton.style!.side!.resolve({})!.width, greaterThan(0));
        expect(wa.top, scale == 1 ? print.top : lessThan(print.top));
        for (final text in tester.widgetList<AppText>(find.byType(AppText))) {
          expect(text.variant, AppTextVariant.bodyStrong);
        }
        expect(tester.getSize(find.text('WhatsApp')).height, lessThan(100));
        if (cod) {
          final pay = tester.getRect(find.widgetWithText(AppButton, 'Catat pembayaran'));
          expect(pay.size, wa.size);
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
        semantics.dispose();
      });
    }
  }
}
