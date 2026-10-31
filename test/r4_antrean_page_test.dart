import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/organisms/order_card.dart';

import 'antrean_test_host.dart';
import 'r4_completion_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('simplified queue maps Review chip and retains proposal rejection', (tester) async {
    final scope = await completionScope(CompletionPrinter());
    final repo = scope.read(orderRepositoryProvider);
    final before = await repo.getOrders();
    await pumpAntrean(tester, container: scope);
    var chips = tester.widget<ChipBar>(find.byType(ChipBar));
    expect(chips.labels, ['Semua 12', 'Perlu dicek 3']);
    expect(chips.selectedIndex, 0);
    await tester.tap(find.text('Perlu dicek 3'));
    await tester.pumpAndSettle();
    expect(scope.read(antreanFilterProvider), 4);
    expect(find.byType(OrderCard), findsNothing);
    await tester.tap(find.text('Tolak').first);
    await tester.pumpAndSettle();
    expect(find.text('Perlu dicek 2'), findsOneWidget);
    chips = tester.widget<ChipBar>(find.byType(ChipBar));
    expect(chips.selectedIndex, 1);
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('Tolak').first);
      await tester.pumpAndSettle();
    }
    expect(find.text('Perlu dicek 0'), findsOneWidget);
    expect(find.text('Belum ada usulan yang perlu dicek'), findsOneWidget);
    expect(await repo.getOrders(), before);
    expect(tester.takeException(), isNull);
  });

  testWidgets('changing mode handles stored status and Review selection without order mutation', (
    tester,
  ) async {
    final host = await pumpAntrean(tester);
    final scope = host.container;
    final business = scope.read(businessRepositoryProvider);
    final repo = scope.read(orderRepositoryProvider);
    final before = await repo.getOrders();
    scope.read(antreanFilterProvider.notifier).select(2);
    await tester.pumpAndSettle();
    final profile = await business.getProfile();
    await business.saveProfile(profile.withOrderStatus(enabled: false));
    scope.invalidate(businessProfileProvider);
    await tester.pumpAndSettle();
    expect(tester.widget<ChipBar>(find.byType(ChipBar)).selectedIndex, 0);
    expect(find.text('Semua 12'), findsOneWidget);
    expect(scope.read(antreanFilterProvider), 2);
    await business.saveProfile(profile);
    scope.invalidate(businessProfileProvider);
    await tester.pumpAndSettle();
    expect(tester.widget<ChipBar>(find.byType(ChipBar)).selectedIndex, 2);
    scope.read(antreanFilterProvider.notifier).select(4);
    await business.saveProfile(profile.withOrderStatus(enabled: false));
    scope.invalidate(businessProfileProvider);
    await tester.pumpAndSettle();
    expect(tester.widget<ChipBar>(find.byType(ChipBar)).selectedIndex, 1);
    expect(await repo.getOrders(), before);
    expect(tester.takeException(), isNull);
  });
}
