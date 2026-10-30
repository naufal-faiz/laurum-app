import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/transactions/pages/service_picker_page.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final location in ['/transaksi/baru', '/order/ord-0127/edit']) {
    testWidgets('create a service from $location, return to picker and select it', (tester) async {
      configureKeyboardTest(tester);
      final host = await pumpAntrean(tester, location: location);
      final before = host.container.read(transactionDraftProvider);
      final label = before.lines.isEmpty ? 'Pilih layanan' : 'Tambah layanan lain';
      final open = find.widgetWithText(AppButton, label);
      await tester.ensureVisible(open);
      await tester.tap(open);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Layanan baru'));
      await tester.pumpAndSettle();
      expect(find.text('Tambah layanan'), findsOneWidget);
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Layanan R3');
      await tester.enterText(fields.at(1), '12000');
      await tester.tap(find.widgetWithText(AppButton, 'Simpan layanan'));
      await tester.pumpAndSettle();
      expect(find.byType(ServicePickerPage), findsOneWidget);
      final catalog = await host.container.read(serviceCatalogProvider.future);
      final saved = catalog.singleWhere((item) => item.name == 'Layanan R3');
      expect(saved.price, 12000);
      final repository = host.container.read(serviceRepositoryProvider);
      expect((await repository.getServices()).any((s) => s.id == saved.id), isTrue);
      expect(host.container.read(transactionDraftProvider).customerId, before.customerId);
      final row = find.text('Layanan R3').first;
      await tester.ensureVisible(row);
      await tester.tap(row);
      await tester.pumpAndSettle();
      final after = host.container.read(transactionDraftProvider);
      expect(after.lineFor(saved.id)?.qtyMilli, 1000);
      expect(after.lines.length, before.lines.length + 1);
      expect(find.byType(ServicePickerPage), findsNothing);
    });
  }
}
