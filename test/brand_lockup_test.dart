import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/molecules/brand_lockup.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';

import '../widgetbook/molecules/brand_lockup_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('BrandLockup shows the logo tile, name and tagline', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: BrandLockup(name: 'LAURUM', tagline: 'LAUNDRY MANAGEMENT'),
        ),
      ),
    );
    expect(find.byType(IconTile), findsOneWidget);
    expect(find.text('LAURUM'), findsOneWidget);
    expect(find.text('LAUNDRY MANAGEMENT'), findsOneWidget);
  });
  registerMoleculeGolden('brand_lockup', brandLockupUseCase.builder);
}
