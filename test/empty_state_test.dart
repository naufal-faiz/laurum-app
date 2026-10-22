import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';

import '../widgetbook/molecules/empty_state_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('EmptyState renders and honors callbacks', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: 'Empty',
            icon: AppIcons.queue,
            actionLabel: 'Retry',
            onAction: () => taps++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Retry'));
    expect(taps, 1);
  });
  registerMoleculeGolden('empty_state', emptyStateUseCase.builder);
}
