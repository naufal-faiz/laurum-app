import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/molecules/feature_strip.dart';

import '../widgetbook/molecules/feature_strip_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('FeatureStrip renders every icon and label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: FeatureStrip(
            items: [
              (icon: AppIcons.queue, label: 'Antrean rapi'),
              (icon: AppIcons.receipt, label: 'Struk otomatis'),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Antrean rapi'), findsOneWidget);
    expect(find.text('Struk otomatis'), findsOneWidget);
  });
  registerMoleculeGolden('feature_strip', featureStripUseCase.builder);
}
