import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

import '../widgetbook/molecules/toggle_row_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('ToggleRow renders and honors callbacks', (tester) async {
    bool? changed;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ToggleRow(label: 'Toggle', value: false, onChanged: (v) => changed = v),
        ),
      ),
    );
    await tester.tap(find.byType(AppSwitch));
    expect(changed, isTrue);
  });
  registerMoleculeGolden('toggle_row', toggleRowUseCase.builder);
}
