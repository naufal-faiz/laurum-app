import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/printer/widgets/printer_format_section.dart';

void main() {
  testWidgets('printer format keeps labels readable and controls tappable at 2x', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    int? font;
    int? paper;
    String? notice;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: PrinterFormatSection(
                paperMm: 58,
                fontSize: 11,
                onEdit:
                    ({
                      paperMm,
                      fontSize,
                      showAddress,
                      showCustomer,
                      showSavings,
                      showNote,
                      footer,
                      note,
                    }) {
                      font = fontSize;
                      paper = paperMm;
                    },
                onNotice: (value) => notice = value,
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    for (final label in ['58 mm', '80 mm', 'Normal', 'Besar']) {
      final button = find.ancestor(of: find.text(label), matching: find.byType(TextButton));
      expect(tester.getSize(button).height, greaterThanOrEqualTo(44));
      final paragraph = tester.renderObject<RenderParagraph>(find.text(label));
      expect(paragraph.didExceedMaxLines, isFalse, reason: label);
    }
    await tester.tap(find.text('Besar'));
    expect(font, 13);
    await tester.tap(find.text('80 mm'));
    expect(notice, contains('coming soon'));
    expect(paper, isNull);
    await tester.tap(find.text('58 mm'));
    expect(paper, 58);
  });
}
