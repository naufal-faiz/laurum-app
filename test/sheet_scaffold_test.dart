import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

import '../widgetbook/templates/sheet_scaffold_use_case.dart';
import 'template_gallery.dart';

void main() {
  testWidgets('SheetScaffold scrolls content and keeps the footer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomSheet(
              title: 'Input berat',
              subtitle: 'Cuci setrika · Rp9.000/kg',
              child: SheetScaffold(
                footer: AppButton('Simpan berat', onPressed: () {}),
                child: const AppText('Isi sheet'),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('Input berat'), findsOneWidget);
    expect(find.text('Isi sheet'), findsOneWidget);
    expect(find.text('Simpan berat'), findsOneWidget);
  });
  registerTemplateGallery('sheet_scaffold', sheetScaffoldUseCases.first.builder);
}
