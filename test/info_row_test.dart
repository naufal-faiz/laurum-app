import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';

import '../widgetbook/molecules/info_row_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('InfoRow renders and honors callbacks', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: InfoRow(label: 'Label', value: 'Value', icon: AppIcons.info),
        ),
      ),
    );
    expect(find.text('Value'), findsOneWidget);
    expect(find.byType(AppIcon), findsOneWidget);
  });
  registerMoleculeGolden('info_row', infoRowUseCase.builder);
}
