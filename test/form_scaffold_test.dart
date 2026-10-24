import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

import '../widgetbook/templates/form_scaffold_use_case.dart';
import 'template_gallery.dart';

void main() {
  testWidgets('FormScaffold shows sticky footer and summary', (tester) async {
    var saves = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: FormScaffold(
          title: 'Catat pengeluaran',
          backLabel: 'Kembali',
          body: const AppText('Isian formulir'),
          summary: const AppText('Total Rp110.000'),
          footer: AppButton('Simpan', onPressed: () => saves++),
        ),
      ),
    );
    expect(find.text('Catat pengeluaran'), findsOneWidget);
    expect(find.text('Isian formulir'), findsOneWidget);
    expect(find.text('Total Rp110.000'), findsOneWidget);
    await tester.tap(find.text('Simpan'));
    expect(saves, 1);
  });
  registerTemplateGallery('form_scaffold', formScaffoldUseCases.first.builder);
}
