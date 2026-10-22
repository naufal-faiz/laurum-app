import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:laurum/shared/widgets/molecules/callout_ai.dart';

import '../widgetbook/molecules/callout_ai_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('CalloutAi renders and honors callbacks', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CalloutAi(message: 'Value')),
      ),
    );
    expect(find.text('Value'), findsOneWidget);
    expect(find.text('Periksa bagian ini'), findsOneWidget);
  });
  registerMoleculeGolden('callout_ai', calloutAiUseCase.builder);
}
