import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/widgets/customer_directory_actions_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

void main() {
  testWidgets('customer actions are compact, equal and keep callbacks at 320px 2x', (tester) async {
    var imports = 0;
    var adds = 0;
    for (final scale in [1.0, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Center(
                child: SizedBox(
                  width: 320,
                  child: CustomerDirectoryActionsSection(
                    onImport: () => imports++,
                    onAdd: () => adds++,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      for (final button in tester.elementList(find.byType(AppButton))) {
        expect(tester.getSize(find.byWidget(button.widget)).height, 48);
      }
      await tester.tap(find.text('Impor kontak'));
      await tester.tap(find.text('Pelanggan baru'));
    }
    expect(imports, 2);
    expect(adds, 2);
  });
}
