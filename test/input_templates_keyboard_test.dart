import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

import 'keyboard_test_helper.dart';

void main() {
  for (final size in [const Size(390, 844), const Size(320, 640)]) {
    for (final sheet in [true, false]) {
      testWidgets('${sheet ? 'Sheet' : 'Form'} keeps input and save above keyboard $size', (
        tester,
      ) async {
        configureKeyboardTest(tester, size: size);
        var saves = 0;
        const body = Column(
          children: [
            SizedBox(height: 400),
            AppTextField(label: 'Catatan', hint: 'Catatan'),
          ],
        );
        final footer = AppButton('Simpan', onPressed: () => saves++);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: sheet
                ? Builder(
                    builder: (context) => Scaffold(
                      body: AppButton(
                        'Buka',
                        onPressed: () => AppBottomSheet.show<void>(
                          context: context,
                          title: 'Formulir',
                          child: SheetScaffold(footer: footer, child: body),
                        ),
                      ),
                    ),
                  )
                : FormScaffold(
                    title: 'Formulir',
                    backLabel: 'Kembali',
                    body: body,
                    footer: footer,
                  ),
          ),
        );
        if (sheet) {
          await tester.tap(find.text('Buka'));
          await tester.pumpAndSettle();
          expect(
            tester.getSize(find.byType(AppBottomSheet)).height,
            lessThanOrEqualTo(size.height * .9),
          );
        }
        await expectKeyboardVisible(
          tester,
          field: find.byType(TextField),
          save: find.widgetWithText(AppButton, 'Simpan'),
        );
        await tester.tap(find.text('Simpan'));
        expect(saves, 1);
        tester.view.viewInsets = const FakeViewPadding();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
