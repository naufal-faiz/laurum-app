import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

import 'keyboard_test_helper.dart';
import 'test_fonts.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('detail form header and keyboard at 320 dp text $scale', (tester) async {
      await loadTestFonts();
      configureKeyboardTest(tester, size: const Size(320, 844));
      var backs = 0;
      var saves = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: FormScaffold(
            title: 'Periksa Usulan AI',
            subtitle: 'Dari pesan WhatsApp',
            backLabel: 'Kembali',
            appBarVariant: AppBarSubVariant.detail,
            onBack: () => backs++,
            footer: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: AppButton('Tolak', onPressed: () {})),
                  Expanded(child: AppButton('Setujui jadi order', onPressed: () => saves++)),
                ],
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 600),
                AppTextField(label: 'Alamat penjemputan', maxLines: 3, onChanged: (_) {}),
              ],
            ),
          ),
        ),
      );
      final headingTop = tester.getTopLeft(find.byType(AppBarSub));
      await expectKeyboardVisible(
        tester,
        field: find.byType(TextField),
        save: find.widgetWithText(AppButton, 'Setujui jadi order'),
      );
      expect(tester.getTopLeft(find.byType(AppBarSub)), headingTop);
      expect(find.text('Dari pesan WhatsApp'), findsNothing);
      await tester.tap(find.text('Setujui jadi order'));
      await tester.tap(find.byTooltip('Kembali'));
      expect((saves, backs), (1, 1));
    });
  }
  testWidgets('detail form golden', (tester) async {
    await loadTestFonts();
    tester.view.physicalSize = const Size(390, 500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RepaintBoundary(
          key: const ValueKey('detail-form'),
          child: FormScaffold(
            title: 'Periksa Usulan AI',
            subtitle: 'Dari pesan WhatsApp',
            backLabel: 'Kembali',
            appBarVariant: AppBarSubVariant.detail,
            onBack: () {},
            footer: AppButton('Setujui jadi order', onPressed: () {}),
            body: const AppText('Periksa dan sesuaikan sebelum menyetujui'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('detail-form')),
      matchesGoldenFile('goldens/detail_form.png'),
    );
  });
}
