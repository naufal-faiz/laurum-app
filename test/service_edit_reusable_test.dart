import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/services/state/service_edit_controller.dart';
import 'package:laurum/features/services/widgets/service_form_footer_section.dart';
import 'package:laurum/features/services/widgets/service_form_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'keyboard_test_helper.dart';
import 'service_create_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final scale in [1.0, 2.0]) {
    testWidgets('edit reuses create form with original values and keyboard at $scale', (
      tester,
    ) async {
      final scope = await pumpServiceCreateUnscaled(
        tester,
        width: scale == 2 ? 280 : 390,
        scale: scale,
        serviceId: 'srv-003',
      );
      final draft = scope.read(serviceEditProvider('srv-003')).value!;
      expect(draft.original, isNotNull);
      expect(find.byType(ServiceFormSection), findsOneWidget);
      expect(find.byType(ServiceFormFooterSection), findsOneWidget);
      final fields = tester.widgetList<AppTextField>(find.byType(AppTextField)).toList();
      expect(fields[0].value, draft.original!.name);
      expect(fields[1].value, '${draft.original!.price}');
      expect(fields[1].selectAllOnFocus, isTrue);
      expect(
        find.text('Perubahan harga tidak memengaruhi nota yang sudah tercetak.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('service-create-golden')),
        matchesGoldenFile('goldens/service_edit_${scale.toInt()}x.png'),
      );
      final save = find.widgetWithText(AppButton, 'Simpan perubahan');
      for (final field in [find.byType(AppTextField).first, find.byType(AppTextField).at(1)]) {
        await expectKeyboardVisible(tester, field: field, save: save);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
