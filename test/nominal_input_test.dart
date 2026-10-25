import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_deposit_controller.dart';
import 'package:laurum/features/transactions/state/cash_input.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  test('uang tunai: tanpa nol di depan dan kosong saat nol', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final input = container.read(cashInputProvider.notifier);

    input.start(0);
    expect(container.read(cashInputProvider), '');
    input.key(AppNumpadKeyValue.zero);
    input.key(AppNumpadKeyValue.five);
    expect(container.read(cashInputProvider), '5');
    input.set(0);
    expect(container.read(cashInputProvider), '');
    input.key(AppNumpadKeyValue.tripleZero);
    expect(container.read(cashInputProvider), '');
    input.set(50000);
    expect(container.read(cashInputProvider), '50000');
  });

  test('setor tabungan: angka pertama mengganti nol, 000 tidak menambah nol', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final deposit = container.read(customerDepositProvider('cust-001').notifier);

    deposit.key(AppNumpadKeyValue.zero);
    expect(container.read(customerDepositProvider('cust-001')).amount, 0);
    deposit.key(AppNumpadKeyValue.five);
    expect(container.read(customerDepositProvider('cust-001')).text, '5');
    deposit.key(AppNumpadKeyValue.tripleZero);
    expect(container.read(customerDepositProvider('cust-001')).text, '5000');
    deposit.add(20000);
    expect(container.read(customerDepositProvider('cust-001')).amount, 25000);
  });

  testWidgets('harga layanan: nol depan dibuang dan nol tunggal tidak disimpan', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya/layanan');
    unawaited(host.router.push('/lainnya/layanan/baru'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Karpet');
    await tester.enterText(find.byType(TextField).at(1), '0');
    await tester.pumpAndSettle();
    final zeroField = tester.widget<AppTextField>(find.byType(AppTextField).at(1));
    expect(zeroField.value, '');
    await tester.tap(find.widgetWithText(AppButton, 'Simpan layanan'));
    await tester.pumpAndSettle();
    expect(find.text('Harga harus lebih dari Rp0.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), '07500');
    await tester.pumpAndSettle();
    final priceField = tester.widget<AppTextField>(find.byType(AppTextField).at(1));
    expect(priceField.value, '7500');
    expect(priceField.selectAllOnFocus, isTrue);
    await tester.tap(find.widgetWithText(AppButton, 'Simpan layanan'));
    await tester.pumpAndSettle();
    final services = await host.container
        .read(serviceRepositoryProvider)
        .getServices(includeInactive: true);
    expect(services.singleWhere((item) => item.name == 'Karpet').price, 7500);
  });
}
