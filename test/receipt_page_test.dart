import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/external_launcher.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/pages/checkout_state.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('saved receipt prints, reports failures and sends WhatsApp', (tester) async {
    final printer = FakePrintService();
    final devices = await printer.discover();
    await printer.connect(devices.first);
    printer.printSucceeds = false;
    final launcher = FakeExternalLauncher();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        printServiceProvider.overrideWithValue(printer),
        externalLauncherProvider.overrideWithValue(launcher),
      ],
    );
    final draft = scope.read(transactionDraftProvider.notifier);
    draft.selectCustomer('cust-001');
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-003'));
    draft.setQuantity('srv-003', 3500);
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    final checkout = scope.read(checkoutControllerProvider.notifier);
    checkout.setSavings(value: true, due: 6500);
    checkout.setMode(PaymentMode.lunas, due: 6500);
    checkout.setReceived(10000, due: 6500);
    final orderId = (await checkout.save())!;

    await pumpAntrean(tester, container: scope, location: '/transaksi/nota/$orderId');
    expect(find.text('Nota tersimpan'), findsWidgets);
    expect(find.text('A-0143'), findsOneWidget);
    expect(find.textContaining('TOTAL'), findsOneWidget);
    await tester.ensureVisible(find.text('Cetak struk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cetak struk'));
    await tester.pumpAndSettle();
    expect(
      find.text('Struk gagal dicetak. Pastikan printer menyala dan Bluetooth aktif.'),
      findsOneWidget,
    );
    expect(find.text('Coba lagi'), findsOneWidget);
    expect(find.text('Pengaturan printer'), findsOneWidget);

    await tester.ensureVisible(find.text('Kirim lewat WhatsApp'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kirim lewat WhatsApp'));
    await tester.pumpAndSettle();
    expect(launcher.whatsAppCalls, hasLength(1));
    expect(launcher.whatsAppCalls.single.phone, '0813-7788-1122');

    await tester.tap(find.text('Lihat order'));
    await tester.pumpAndSettle();
    expect(find.text('Detail order'), findsWidgets);
  });
}
