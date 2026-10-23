import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/footer_bar.dart';

import '../widgetbook/molecules/footer_bar_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('FooterBar renders and honors callbacks', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: FooterBar(
            summary: const AppText('Summary'),
            child: AppButton('Submit', onPressed: () => taps++),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Submit'));
    expect(taps, 1);
    expect(find.text('Summary'), findsOneWidget);
  });
  registerMoleculeGolden('footer_bar', footerBarUseCase.builder);
}
