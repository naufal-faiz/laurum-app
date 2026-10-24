import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

import '../widgetbook/organisms/bottom_nav_bar_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('BottomNavBar labels, active glyph and external selection', (tester) async {
    var selected = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          bottomNavigationBar: BottomNavBar(activeIndex: 1, onSelected: (i) => selected = i),
        ),
      ),
    );
    expect(find.text('Antrean'), findsOneWidget);
    expect(find.text('Lainnya'), findsOneWidget);
    expect(
      tester.widgetList<AppIcon>(find.byType(AppIcon)).map((i) => i.icon),
      contains(AppIcons.customersActive),
    );
    await tester.tap(find.text('Transaksi'));
    expect(selected, 2);
    expect(
      tester.widgetList<AppIcon>(find.byType(AppIcon)).map((i) => i.icon),
      contains(AppIcons.customersActive),
    );
  });
  registerMoleculeGolden('bottom_nav_bar', bottomNavBarUseCase.builder);
}
