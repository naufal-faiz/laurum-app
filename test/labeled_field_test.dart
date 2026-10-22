import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

import '../widgetbook/molecules/labeled_field_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('LabeledField renders and honors callbacks', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LabeledField(
            label: 'Label',
            helperText: 'Hint',
            errorText: 'Required',
            child: AppTextField(label: 'Input'),
          ),
        ),
      ),
    );
    expect(find.text('Required'), findsOneWidget);
    expect(find.text('Hint'), findsNothing);
    await tester.enterText(find.byType(TextField), 'Value');
    expect(find.text('Value'), findsOneWidget);
  });
  registerMoleculeGolden('labeled_field', labeledFieldUseCase.builder);
}
