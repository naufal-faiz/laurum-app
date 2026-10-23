import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/molecules/nominal_chips.dart';

import '../widgetbook/molecules/nominal_chips_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('NominalChips renders and honors callbacks', (tester) async {
    int? amount;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: NominalChips(amounts: const [1000, 2000], onSelected: (value) => amount = value),
        ),
      ),
    );
    await tester.tap(find.text('+${Formatters.rupiah(1000)}'));
    expect(amount, 1000);
  });
  registerMoleculeGolden('nominal_chips', nominalChipsUseCase.builder);
}
