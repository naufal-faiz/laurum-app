import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';

import '../widgetbook/molecules/app_bar_sub_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('AppBarSub renders and honors callbacks', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppBarSub(title: 'Subpage', backLabel: 'Back', onBack: () => taps++),
        ),
      ),
    );
    await tester.tap(find.byType(AppIconButton));
    expect(taps, 1);
    expect(find.text('Subpage'), findsOneWidget);
  });
  registerMoleculeGolden('app_bar_sub', appBarSubUseCase.builder);
}
