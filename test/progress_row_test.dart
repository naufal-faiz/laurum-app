import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';

import 'package:laurum/shared/widgets/molecules/progress_row.dart';

import '../widgetbook/molecules/progress_row_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('ProgressRow renders and honors callbacks', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: ProgressRow(label: 'Progress', progress: 0.5, value: 'Value'),
        ),
      ),
    );
    expect(tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value, 0.5);
  });
  registerMoleculeGolden('progress_row', progressRowUseCase.builder);
}
