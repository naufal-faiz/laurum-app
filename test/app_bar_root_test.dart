import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_root.dart';

import '../widgetbook/molecules/app_bar_root_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('AppBarRoot renders and honors callbacks', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppBarRoot(
            title: 'Business',
            accountLabel: 'Account',
            syncIndicator: const AppText('Saved'),
            onAccount: () => taps++,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(AppIconButton));
    expect(taps, 1);
    expect(find.text('Saved'), findsOneWidget);
  });
  registerMoleculeGolden('app_bar_root', appBarRootUseCase.builder);
}
