import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

import '../widgetbook/organisms/app_bottom_sheet_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('AppBottomSheet.show presents content and closes', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: AppButton(
                'Buka',
                onPressed: () => AppBottomSheet.show<void>(
                  context: context,
                  title: 'Pembayaran',
                  subtitle: 'Nota A-0143 · Pak Dedi',
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: AppText('Isi sheet'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    expect(find.text('Pembayaran'), findsOneWidget);
    expect(find.text('Isi sheet'), findsOneWidget);
    await tester.tap(find.byTooltip('Tutup'));
    await tester.pumpAndSettle();
    expect(find.text('Isi sheet'), findsNothing);
  });
  registerOrganismGallery('app_bottom_sheet', appBottomSheetUseCase.builder, height: 600);
}
