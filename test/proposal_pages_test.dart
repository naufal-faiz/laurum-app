import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/pages/order_edit_page.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('Rina address confirmation, approval and Edit weight route', (tester) async {
    final host = await pumpAntrean(tester, location: '/antrean/usulan/prop-002');
    expect(find.text('Bu Rina'), findsOneWidget);
    expect(find.textContaining('Periksa dan sesuaikan'), findsOneWidget);
    await tester.tap(find.widgetWithText(AppButton, 'Setujui jadi order'));
    await tester.pumpAndSettle();
    expect(find.text('Alamat belum dipastikan'), findsOneWidget);
    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();
    expect(
      (await host.container.read(proposalRepositoryProvider).getProposalById('prop-002'))!.status,
      ProposalStatus.menunggu,
    );
    await tester.tap(find.widgetWithText(AppButton, 'Setujui jadi order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Setujui jadi order').last);
    await tester.pumpAndSettle();
    final fill = find.text('Isi berat lewat Edit order');
    expect(fill, findsOneWidget);
    await tester.ensureVisible(fill);
    await tester.tap(fill);
    await tester.pumpAndSettle();
    expect(tester.widget<OrderEditPage>(find.byType(OrderEditPage)).orderId, 'ord-ai-prop-002');
  });
  testWidgets('new customer is not created when proposal is rejected', (tester) async {
    final host = await pumpAntrean(tester, location: '/antrean/usulan/prop-003');
    expect(find.text('Belum terdaftar'), findsOneWidget);
    expect((await host.container.read(customerRepositoryProvider).getCustomers()).length, 48);
    await tester.tap(find.widgetWithText(AppButton, 'Tolak'));
    await tester.pumpAndSettle();
    expect(find.text('Tolak usulan ini?'), findsOneWidget);
    await tester.tap(find.text('Tolak').last);
    await tester.pumpAndSettle();
    expect(
      (await host.container.read(proposalHistoryProvider.future)).count(ProposalStatus.ditolak),
      9,
    );
    expect((await host.container.read(customerRepositoryProvider).getCustomers()).length, 48);
  });
  testWidgets('Rudi cancellation needs explicit confirmation', (tester) async {
    final host = await pumpAntrean(tester, location: '/antrean/usulan/prop-001');
    await tester.tap(find.widgetWithText(AppButton, 'Batalkan order'));
    await tester.pumpAndSettle();
    expect(find.text('Batalkan order A-0139?'), findsOneWidget);
    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();
    expect(
      (await host.container.read(orderRepositoryProvider).getOrderById('ord-0139'))!.status,
      OrderStatus.menungguJemput,
    );
    await tester.tap(find.widgetWithText(AppButton, 'Batalkan order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, batalkan order'));
    await tester.pumpAndSettle();
    expect(
      (await host.container.read(orderRepositoryProvider).getOrderById('ord-0139'))!.status,
      OrderStatus.dibatalkan,
    );
  });
}
