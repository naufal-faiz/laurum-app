import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';

import '../widgetbook/molecules/stat_tile_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('StatTile renders and honors callbacks', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: StatTile(label: 'Metric', value: 'Value', description: 'Detail'),
        ),
      ),
    );
    expect(find.text('Value'), findsOneWidget);
    expect(find.byType(AppCard), findsOneWidget);
  });
  registerMoleculeGolden('stat_tile', statTileUseCase.builder);
}
