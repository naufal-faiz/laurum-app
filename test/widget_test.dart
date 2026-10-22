import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/main_dummy.dart' as dummy;

void main() {
  testWidgets('Dummy entry point shows an empty themed app', (tester) async {
    await dummy.main();
    await tester.pumpAndSettle();
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    final theme = Theme.of(tester.element(find.byType(Scaffold)));
    expect(scaffold.body, isNull);
    expect(scaffold.appBar, isNull);
    expect(scaffold.floatingActionButton, isNull);
    expect(theme.scaffoldBackgroundColor, AppColors.bg);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.textTheme.bodyMedium?.fontFamily, AppTextStyles.fontFamily);
    expect(find.text('Flutter Demo'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
