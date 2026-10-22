import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

void main() {
  testWidgets('field edits, submits, syncs values and disposes owned controller', (tester) async {
    String? changed, submitted;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppTextField(
            label: 'Input',
            hint: 'Hint',
            value: '12',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.done,
            onChanged: (value) => changed = value,
            onSubmitted: (value) => submitted = value,
          ),
        ),
      ),
    );
    final field = find.byType(TextField);
    final controller = tester.widget<TextField>(field).controller!;
    expect(controller.text, '12');
    await tester.enterText(field, '34x');
    expect(changed, '34');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, '34');
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AppTextField(label: 'Input', value: '56', errorText: 'Invalid'),
        ),
      ),
    );
    expect(controller.text, '56');
    expect(controller.selection.baseOffset, 2);
    expect(find.text('Invalid'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    expect(() => controller.addListener(() {}), throwsFlutterError);
  });
  testWidgets('field renders disabled, read only, obscured and multiline options', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Column(
            children: [
              AppTextField(label: 'Disabled', enabled: false),
              AppTextField(label: 'Read only', value: 'Read only', readOnly: true),
              AppTextField(label: 'Password', value: 'secret', obscureText: true),
              AppTextField(label: 'Multiline', minLines: 2, maxLines: 4),
            ],
          ),
        ),
      ),
    );
    final fields = tester.widgetList<TextField>(find.byType(TextField)).toList();
    expect(fields[0].enabled, isFalse);
    expect(fields[1].readOnly, isTrue);
    expect(fields[2].obscureText, isTrue);
    expect(fields[3].maxLines, 4);
    expect(tester.takeException(), isNull);
  });
}
