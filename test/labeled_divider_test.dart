import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/molecules/labeled_divider.dart';

import '../widgetbook/molecules/labeled_divider_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('LabeledDivider shows the label between two lines', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LabeledDivider('atau'))),
    );
    expect(find.text('atau'), findsOneWidget);
    expect(find.byType(AppDivider), findsNWidgets(2));
  });
  registerMoleculeGolden('labeled_divider', labeledDividerUseCase.builder);
}
