import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';

import 'package:laurum/shared/widgets/molecules/section_header.dart';

import '../widgetbook/molecules/section_header_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('SectionHeader renders and honors callbacks', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SectionHeader(title: 'Section', actionLabel: 'Action', onAction: () => taps++),
        ),
      ),
    );
    expect(find.text('Section'), findsOneWidget);
    await tester.tap(find.text('Action'));
    expect(taps, 1);
  });
  registerMoleculeGolden('section_header', sectionHeaderUseCase.builder);
}
