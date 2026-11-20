import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'keyboard_test_helper.dart';
import 'service_create_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final width in [280.0, 390.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('create service keyboard300 width$width actual font$scale', (tester) async {
        await pumpServiceCreateUnscaled(tester, width: width, scale: scale);
        final save = find.widgetWithText(AppButton, 'Simpan layanan');
        for (final field in [find.byType(AppTextField).first, find.byType(AppTextField).at(1)]) {
          await expectKeyboardVisible(tester, field: field, save: save);
        }
      });
    }
  }
}
