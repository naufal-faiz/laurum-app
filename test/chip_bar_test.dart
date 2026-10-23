import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';

import '../widgetbook/molecules/chip_bar_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('ChipBar renders and honors callbacks', (tester) async {
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ChipBar(
            labels: const ['A', 'B'],
            selectedIndex: 0,
            onSelected: (value) => selected = value,
          ),
        ),
      ),
    );
    await tester.tap(find.text('B'));
    expect(selected, 1);
    expect(tester.widget<AppChip>(find.byType(AppChip).first).selected, isTrue);
  });
  registerMoleculeGolden('chip_bar', chipBarUseCase.builder);
}
