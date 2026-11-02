import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/orders/widgets/payment_record_input_section.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';
import 'package:laurum/features/transactions/widgets/payment_method_section.dart';
import 'package:laurum/features/transactions/widgets/payment_savings_section.dart';
import 'package:laurum/features/transactions/widgets/payment_summary_section.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';

import 'r9_section_host.dart';

void main() {
  testWidgets('summary has only two payment choices and delegates COD', (tester) async {
    PayTerm? selected;
    await pumpR9Section(
      tester,
      PaymentSummarySection(
        customerName: 'Dedi',
        itemCount: 1,
        total: 25000,
        term: PayTerm.sekarang,
        onTerm: (term) => selected = term,
      ),
    );
    await tester.tap(find.text('Bayar nanti (COD)'));
    expect(selected, PayTerm.cod);
    expect(find.text('DP'), findsNothing);
    expect(find.text('Belum bayar'), findsNothing);
  });
  testWidgets('savings section shows allocation and delegates toggle', (tester) async {
    var enabled = false;
    final quote = quotePayment(
      total: 25000,
      balance: 18500,
      state: const CheckoutState(payTerm: PayTerm.cod, useSavings: true),
    );
    await pumpR9Section(
      tester,
      PaymentSavingsSection(
        balance: 18500,
        quote: quote,
        useSavings: false,
        onChanged: (value) => enabled = value,
      ),
    );
    expect(find.text('Tabungan dipakai -Rp18.500'), findsOneWidget);
    expect(find.text('Sisa bayar Rp6.500'), findsOneWidget);
    await tester.tap(find.byType(AppSwitch));
    expect(enabled, isTrue);
  });
  testWidgets('method section delegates excess and amount actions', (tester) async {
    var save = false, opened = false;
    const state = CheckoutState(received: 30000);
    await pumpR9Section(
      tester,
      PaymentMethodSection(
        checkout: state,
        quote: quotePayment(total: 25000, balance: 0, state: state),
        onMethod: (_) {},
        onAmount: () => opened = true,
        onExcess: (value) => save = value,
      ),
    );
    await tester.tap(find.text('Simpan ke tabungan'));
    await tester.tap(find.text('Uang diterima'));
    expect(save, isTrue);
    expect(opened, isTrue);
    expect(find.text('Kembali Rp5.000'), findsOneWidget);
  });
  testWidgets('record input permits cash excess and delegates savings choice', (tester) async {
    var save = false;
    await pumpR9Section(
      tester,
      PaymentRecordInputSection(
        amount: 30000,
        due: 25000,
        method: PayMethod.tunai,
        saveExcess: false,
        onMethod: (_) {},
        onExcess: (value) => save = value,
        onKey: (_) {},
      ),
    );
    expect(find.text('Kelebihan Rp5.000'), findsOneWidget);
    await tester.tap(find.text('Simpan ke tabungan'));
    expect(save, isTrue);
  });
}
