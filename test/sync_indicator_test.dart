import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';

import '../widgetbook/molecules/sync_indicator_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('SyncIndicator renders and honors callbacks', (tester) async {
    for (final state in SyncState.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SyncIndicator(state: state)),
        ),
      );
      expect(find.byType(AppIcon), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Gagal'), findsOneWidget);
  });
  registerMoleculeGolden('sync_indicator', syncIndicatorUseCase.builder);
}
