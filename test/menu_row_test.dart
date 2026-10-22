import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

import '../widgetbook/molecules/menu_row_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('MenuRow renders and honors callbacks', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MenuRow(label: 'Menu', icon: AppIcons.service, onTap: () => taps++),
        ),
      ),
    );
    await tester.tap(find.text('Menu'));
    expect(taps, 1);
  });
  registerMoleculeGolden('menu_row', menuRowUseCase.builder);
}
