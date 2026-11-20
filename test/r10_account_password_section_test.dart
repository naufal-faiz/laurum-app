import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/auth/widgets/account_password_section.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

import 'r10_test_host.dart';

void main() {
  testWidgets('Google password hint is read-only, email password action remains available', (
    tester,
  ) async {
    var edits = 0;
    for (final usesPassword in [false, true]) {
      await pumpAuthSection(
        tester,
        AccountPasswordSection(
          usesPassword: usesPassword,
          busy: false,
          onPassword: () => edits++,
        ),
      );
      expect(
        find.widgetWithText(MenuRow, 'Ganti password'),
        usesPassword ? findsOneWidget : findsNothing,
      );
      if (usesPassword) {
        await tester.tap(find.text('Ganti password'));
        expect(edits, 1);
      } else {
        expect(find.text('Masuk dengan Google. Ganti password tidak tersedia.'), findsOneWidget);
      }
    }
    await pumpAuthSection(
      tester,
      AccountPasswordSection(
        usesPassword: true,
        busy: true,
        onPassword: () => edits++,
      ),
    );
    expect(tester.widget<MenuRow>(find.byType(MenuRow)).onTap, isNull);
  });
}
