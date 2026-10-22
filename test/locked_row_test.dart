import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/molecules/locked_row.dart';

import '../widgetbook/molecules/locked_row_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('LockedRow renders and honors callbacks', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: LockedRow(label: 'Locked', lockLabel: 'Always visible'),
        ),
      ),
    );
    expect(find.text('Always visible'), findsOneWidget);
    expect(tester.widget<AppIcon>(find.byType(AppIcon)).icon, AppIcons.lock);
  });
  registerMoleculeGolden('locked_row', lockedRowUseCase.builder);
}
