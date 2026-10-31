import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

import 'keyboard_test_helper.dart';

void main() {
  testWidgets('SubScaffold FAB hides for keyboard and returns after dismissal', (tester) async {
    configureKeyboardTest(tester);
    var creates = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: SubScaffold(
          title: 'Pilih layanan',
          backLabel: 'Kembali',
          fabLabel: 'Layanan baru',
          onFab: () => creates++,
          body: const AppTextField(label: 'Cari layanan'),
        ),
      ),
    );
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.tap(find.text('Layanan baru'));
    expect(creates, 1);
    await tester.showKeyboard(find.byType(TextField));
    tester.view.viewInsets = const FakeViewPadding(bottom: 600);
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsNothing);
    tester.view.viewInsets = const FakeViewPadding();
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
