import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/auth/state/account_edit.dart';
import 'package:laurum/features/auth/widgets/account_danger_section.dart';
import 'package:laurum/features/auth/widgets/account_edit_field_section.dart';
import 'package:laurum/features/auth/widgets/account_profile_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'r10_test_host.dart';

void main() {
  testWidgets('account profile has read-only email and delegates name edit', (tester) async {
    var names = 0;
    await pumpAuthSection(
      tester,
      AccountProfileSection(
        data: (
          name: 'Bu Ratna',
          email: 'ratna@example.com',
          phone: '',
          googleLinked: true,
          usesPassword: false,
        ),
        busy: false,
        onName: () => names++,
        onPhone: () {},
        onPassword: () {},
      ),
    );
    expect(find.text('Ganti email belum tersedia'), findsOneWidget);
    expect(find.text('Masuk dengan Google. Ganti password tidak tersedia.'), findsOneWidget);
    await tapAuthText(tester, 'Nama');
    expect(names, 1);
  });
  testWidgets('danger zone disables deletion offline and delegates logout', (tester) async {
    var exits = 0;
    await pumpAuthSection(
      tester,
      AccountDangerSection(busy: false, offline: true, onLogout: () => exits++, onDelete: () {}),
    );
    expect(find.text('Zona berbahaya'), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Hapus akun')).onPressed,
      isNull,
    );
    await tapAuthButton(tester, 'Keluar');
    expect(exits, 1);
  });
  testWidgets('profile field selects initial value and shows validation', (tester) async {
    String? edited;
    await pumpAuthSection(
      tester,
      AccountEditFieldSection(
        field: AccountField.phone,
        data: (value: '081234567890', busy: false, error: 'Nomor tidak valid'),
        onChanged: (value) => edited = value,
      ),
    );
    expect(tester.widget<AppTextField>(find.byType(AppTextField)).selectAllOnFocus, isTrue);
    expect(find.text('Nomor tidak valid'), findsOneWidget);
    await tester.enterText(authField('No. telp'), '+6281234567890');
    expect(edited, '+6281234567890');
  });
}
