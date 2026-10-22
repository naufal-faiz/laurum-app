import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';

import 'package:laurum/shared/widgets/molecules/date_group_header.dart';

import '../widgetbook/molecules/date_group_header_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('DateGroupHeader renders and honors callbacks', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: DateGroupHeader(label: 'Date', summary: 'Summary'),
        ),
      ),
    );
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Summary'), findsOneWidget);
  });
  registerMoleculeGolden('date_group_header', dateGroupHeaderUseCase.builder);
}
