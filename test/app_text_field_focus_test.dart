import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

void main() {
  for (final selectAll in [true, false]) {
    testWidgets('selectAllOnFocus=$selectAll handles tap, refocus and disposal', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Column(
              children: [
                AppTextField(label: 'Nominal', value: '5000', selectAllOnFocus: selectAll),
                const AppTextField(label: 'Catatan'),
              ],
            ),
          ),
        ),
      );
      final fields = find.byType(TextField);
      final input = tester.widget<TextField>(fields.first);
      await tester.tap(fields.first);
      await tester.pumpAndSettle();
      if (selectAll) {
        expect(input.controller!.selection, const TextSelection(baseOffset: 0, extentOffset: 4));
        tester.testTextInput.updateEditingValue(
          const TextEditingValue(
            text: '7',
            selection: TextSelection.collapsed(offset: 1),
          ),
        );
        await tester.pump();
        expect(input.controller!.text, '7');
        expect(input.controller!.selection.isCollapsed, isTrue);
      } else {
        expect(input.controller!.selection.isCollapsed, isTrue);
      }
      await tester.tap(fields.last);
      await tester.pumpAndSettle();
      await tester.tap(fields.first);
      await tester.pumpAndSettle();
      if (selectAll) {
        expect(input.controller!.selection, const TextSelection(baseOffset: 0, extentOffset: 1));
      }
      final focus = input.focusNode!;
      await tester.pumpWidget(const SizedBox());
      expect(() => focus.addListener(() {}), throwsFlutterError);
      expect(tester.takeException(), isNull);
    });
  }
}
