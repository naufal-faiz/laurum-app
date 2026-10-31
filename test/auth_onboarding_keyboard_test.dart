import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('onboarding Info Usaha field and save above 300dp keyboard', (tester) async {
    configureKeyboardTest(tester, size: const Size(320, 844));
    final scope = ProviderContainer(
      overrides: dummyOverrides(
        authService: FakeAuthService(needsBusinessSetup: true),
      ),
    );
    await pumpAntrean(tester, container: scope);
    final name = find.descendant(
      of: find.byWidgetPredicate((w) => w is AppTextField && w.label == 'Nama usaha'),
      matching: find.byType(TextField),
    );
    await expectKeyboardVisible(
      tester,
      field: name,
      save: find.widgetWithText(AppButton, 'Simpan'),
    );
  });
}
