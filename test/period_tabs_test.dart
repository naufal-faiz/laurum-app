import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';

import 'package:laurum/shared/widgets/molecules/period_tabs.dart';

import '../widgetbook/molecules/period_tabs_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('PeriodTabs renders and honors callbacks', (tester) async {
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: PeriodTabs(
            labels: const ['Day', 'Week'],
            selectedIndex: 0,
            onSelected: (value) => selected = value,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Week'));
    expect(selected, 1);
  });
  registerMoleculeGolden('period_tabs', periodTabsUseCase.builder);
}
