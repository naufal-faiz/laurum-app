import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/external_launcher.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/organisms/customer_row.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('directory WhatsApp icon opens the customer chat without dialing', (tester) async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    await pumpAntrean(tester, location: '/pelanggan', container: scope);
    await tester.enterText(find.byType(TextField), '081377881122');
    await tester.pumpAndSettle();
    final contact = find.descendant(
      of: find.byType(CustomerRow),
      matching: find.byType(AppIconButton),
    );
    await tester.tap(contact.first);
    await tester.pumpAndSettle();
    final launcher = scope.read(externalLauncherProvider) as FakeExternalLauncher;
    expect(launcher.whatsAppCalls.single, (phone: '0813-7788-1122', message: ''));
    expect(launcher.launchedUrls, isEmpty);
  });
}
