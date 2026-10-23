import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';

import 'package:laurum/shared/widgets/molecules/stepper_field.dart';

import '../widgetbook/molecules/stepper_field_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('StepperField renders and honors callbacks', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: StepperField(
            value: 'Value',
            decreaseLabel: 'Decrease',
            increaseLabel: 'Increase',
            editLabel: 'Edit',
            onIncrease: () => taps++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('+'));
    expect(taps, 1);
    await tester.tap(find.text('−'));
    expect(taps, 1);
  });
  registerMoleculeGolden('stepper_field', stepperFieldUseCase.builder);
}
