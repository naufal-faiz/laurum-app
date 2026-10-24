import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/organisms/receipt_preview.dart';

import '../widgetbook/organisms/receipt_preview_use_case.dart';
import 'organism_gallery.dart';
import 'receipt_template_lines.dart';

void main() {
  testWidgets('ReceiptPreview renders the formatted receipt unchanged', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ReceiptPreview(lines: receiptTemplateLines),
          ),
        ),
      ),
    );
    expect(find.byType(AppText), findsNWidgets(receiptTemplateLines.length));
    expect(find.text(receiptTemplateLines.first), findsOneWidget);
    expect(find.text('STATUS: LUNAS'), findsOneWidget);
  });
  registerOrganismGallery('receipt_preview', receiptPreviewUseCase.builder, height: 1200);
}
