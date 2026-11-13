import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/services/receipt_png.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/organisms/receipt_document.dart';

import 'test_fonts.dart';

ReceiptDocumentData imageReceipt({double width = 320, int lines = 1, bool? settled}) =>
    ReceiptDocumentData(
      title: 'LAURUM LAUNDRY',
      header: const ['Jl. Mawar 12', '0812-3456-7890'],
      width: width,
      fileName: 'struk-test',
      settled: settled ?? width == 320,
      status: (settled ?? width == 320) ? 'Pembayaran lunas' : 'COD - Sisa Rp70.000',
      statusDetail: 'Tunai',
      groups: [
        const [
          ReceiptDocumentRow('No. Nota', 'A-0001'),
          ReceiptDocumentRow(
            'Pelanggan',
            'Ibu Sari',
            valueDetail: 'Alamat pelanggan yang panjang dan dibungkus',
          ),
        ],
        [
          for (var i = 0; i < lines; i++)
            ReceiptDocumentRow('Cuci setrika $i', 'Rp35.000', detail: '5 kg × Rp7.000'),
        ],
        const [ReceiptDocumentRow('TOTAL', 'Rp70.000', emphasis: true)],
      ],
      footerTitle: 'Terima kasih',
      footer: const ['Terima kasih', 'Simpan struk sampai pengambilan'],
    );
void main() {
  setUpAll(loadTestFonts);
  for (final (width, settled) in [(320.0, true), (384.0, false), (320.0, false)]) {
    testWidgets('WhatsApp PNG matches the full preview at width $width, settled=$settled', (
      tester,
    ) async {
      final data = imageReceipt(width: width, settled: settled);
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: width,
                  child: RepaintBoundary(
                    key: key,
                    child: Material(
                      color: AppColors.surface,
                      child: ReceiptDocument(data: data),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      ui.Image? golden;
      addTearDown(() => golden?.dispose());
      await tester.runAsync(() async {
        final png = await receiptPng(data);
        final codec = await ui.instantiateImageCodec(png);
        final exported = (await codec.getNextFrame()).image;
        golden = exported;
        final visible = await (key.currentContext!.findRenderObject()! as RenderRepaintBoundary)
            .toImage(pixelRatio: 2);
        try {
          expect(exported.width, visible.width);
          expect(exported.height, visible.height);
          final a = await exported.toByteData(), b = await visible.toByteData();
          expect(listEquals(a!.buffer.asUint8List(), b!.buffer.asUint8List()), isTrue);
        } finally {
          visible.dispose();
          codec.dispose();
        }
      });
      if (settled || width == 384) {
        await expectLater(
          golden!,
          matchesGoldenFile('goldens/receipt_whatsapp_${width.toInt()}.png'),
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
  test('PNG includes a receipt much taller than the phone viewport', () async {
    final png = await receiptPng(imageReceipt(lines: 120));
    final codec = await ui.instantiateImageCodec(png);
    final image = (await codec.getNextFrame()).image;
    expect(image.width, 640);
    expect(image.height, greaterThan(6000));
    image.dispose();
    codec.dispose();
  });
}
