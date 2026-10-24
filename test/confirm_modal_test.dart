import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

import '../widgetbook/organisms/confirm_modal_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('ConfirmModal.show returns true for destructive confirm', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: AppButton(
              'Hapus',
              onPressed: () async => result = await ConfirmModal.show(
                context: context,
                title: 'Hapus pengeluaran ini?',
                message: 'Rp110.000 - Deterjen cair Matic 2 jerigen (10 L).',
                confirmLabel: 'Hapus',
                destructive: true,
                icon: AppIcons.alert,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus pengeluaran ini?'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(Dialog),
        matching: find.widgetWithText(AppButton, 'Hapus'),
      ),
    );
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('ConfirmModal.show returns false from cancel', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: AppButton(
              'Keluar',
              onPressed: () async => result = await ConfirmModal.show(
                context: context,
                title: 'Keluar tanpa menyimpan?',
                message: 'Nota A-0143 belum disimpan dan akan hilang.',
                confirmLabel: 'Keluar tanpa simpan',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });
  registerOrganismGallery('confirm_modal', confirmModalUseCase.builder, height: 800);
}
