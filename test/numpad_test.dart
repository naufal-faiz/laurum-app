import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';

import '../widgetbook/organisms/numpad_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('Numpad emits keys and shows optional nominal chips', (tester) async {
    final keys = <AppNumpadKeyValue>[];
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Numpad(
            onKey: keys.add,
            amounts: const [5000, 10000],
            selectedAmount: 5000,
            onNominalSelected: (value) => selected = value,
          ),
        ),
      ),
    );
    expect(find.text('000'), findsOneWidget);
    await tester.tap(find.text('7'));
    expect(keys.single, AppNumpadKeyValue.seven);
    await tester.tap(find.text('+Rp10.000'));
    expect(selected, 10000);
  });

  testWidgets('Numpad decimal variant replaces 000 with a comma', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Numpad(variant: NumpadVariant.decimal, onKey: (_) {}),
        ),
      ),
    );
    expect(find.text(','), findsOneWidget);
    expect(find.text('000'), findsNothing);
  });
  registerOrganismGallery('numpad', numpadUseCase.builder, height: 800);
}
