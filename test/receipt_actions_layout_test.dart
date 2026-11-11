import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/transactions/widgets/receipt_actions_section.dart';
import 'package:laurum/features/transactions/widgets/receipt_links_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

import 'r9_section_host.dart';

void main() {
  for (final cod in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('receipt actions COD=$cod scale=$scale stay compact and readable', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        try {
          tester.view.physicalSize = const Size(320, 900);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final calls = <String>[];
          await pumpR9Section(
            tester,
            MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Column(
                children: [
                  ReceiptActionsSection(
                    busy: false,
                    onPrint: () => calls.add('print'),
                    onWhatsApp: () => calls.add('wa'),
                    onHome: () => calls.add('home'),
                    onDownload: () => calls.add('download'),
                  ),
                  ReceiptLinksSection(
                    busy: false,
                    onOrder: () => calls.add('order'),
                    onRecord: cod ? () => calls.add('pay') : null,
                  ),
                ],
              ),
            ),
          );
          expect(tester.takeException(), isNull);
          expect(find.text('Transaksi baru'), findsNothing);
          expect(find.text('Ke beranda'), findsNothing);
          expect(find.text('Cetak struk'), findsNothing);
          expect(find.bySemanticsLabel('Cetak struk'), findsOneWidget);
          final wa = tester.getRect(find.byTooltip('WhatsApp'));
          final print = tester.getRect(find.byTooltip('Cetak struk'));
          final home = tester.getRect(find.widgetWithText(AppButton, 'Selesai'));
          final download = tester.getRect(find.byTooltip('Unduh'));
          expect(print.size, wa.size);
          expect(download.size, wa.size);
          expect(home.height, greaterThanOrEqualTo(wa.height));
          expect(print.center.dy, wa.center.dy);
          expect(home.center.dy, wa.center.dy);
          expect(home.right, lessThan(wa.left));
          expect(wa.right, lessThan(download.left));
          expect(download.right, lessThan(print.left));
          expect(
            tester
                .widget<AppIconButton>(
                  find.byWidgetPredicate((w) => w is AppIconButton && w.label == 'Cetak struk'),
                )
                .onPressed,
            isNotNull,
          );
          for (final text in tester.widgetList<AppText>(find.byType(AppText))) {
            expect(text.variant.style.fontSize, greaterThanOrEqualTo(11));
          }
          expect(tester.getSize(find.text('Selesai')).height, lessThan(100));
          if (cod) expect(find.text('Catat pembayaran'), findsOneWidget);
          for (final target in [
            find.byTooltip('WhatsApp'),
            find.byTooltip('Cetak struk'),
            find.text('Selesai'),
            find.text('Lihat detail'),
            if (cod) find.text('Catat pembayaran'),
            find.byTooltip('Unduh'),
          ]) {
            await tester.tap(target);
          }
          expect(calls, ['wa', 'print', 'home', 'order', if (cod) 'pay', 'download']);
        } finally {
          semantics.dispose();
        }
      });
    }
  }
}
