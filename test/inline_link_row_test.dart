import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';
import 'package:laurum/shared/widgets/molecules/inline_link_row.dart';

import '../widgetbook/molecules/inline_link_row_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('InlineLinkRow renders the question and triggers its link', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InlineLinkRow(
            question: 'Belum punya akun?',
            action: 'Daftar',
            onTap: () => taps++,
          ),
        ),
      ),
    );
    expect(find.text('Belum punya akun?'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
    await tester.tap(find.text('Daftar'));
    expect(taps, 1);
  });

  testWidgets('InlineLink is inactive without a callback', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: InlineLink('Lupa password?'))),
    );
    expect(tester.widget<TextButton>(find.byType(TextButton)).onPressed, isNull);
    await tester.tap(find.text('Lupa password?'));
    expect(tester.takeException(), isNull);
  });
  registerMoleculeGolden('inline_link_row', inlineLinkRowUseCase.builder);
}
