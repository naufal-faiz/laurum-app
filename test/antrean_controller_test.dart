import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/pages/antrean_controller.dart';
import 'package:laurum/features/orders/pages/antrean_data.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  late ProviderContainer container;
  setUp(() => container = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => container.dispose());
  test('fixture counts, money and summaries match DATA MASTER', () async {
    final data = await container.read(antreanDataProvider.future);
    expect(data.chips, ['Semua 12', 'Jemput 3', 'Proses 5', 'Siap 4', 'Perlu dicek 3']);
    final dedi = data.orders.singleWhere((o) => o.id == 'ord-0142');
    expect(data.summary(dedi), 'Cuci kiloan 4,5 kg');
    expect(dedi.total, 31500);
    expect(data.paymentStatus(dedi), PayStatus.belumBayar);
  });
  test('advance is reactive, records one event and ignores double submission', () async {
    await container.read(antreanDataProvider.future);
    final actions = container.read(antreanActionsProvider.notifier);
    await Future.wait([
      actions.advance('ord-0142', OrderStatus.diproses),
      actions.advance('ord-0142', OrderStatus.diproses),
    ]);
    final data = await container.read(antreanDataProvider.future);
    expect(data.chips[2], 'Proses 4');
    expect(data.chips[3], 'Siap 5');
    final repository = container.read(orderRepositoryProvider);
    final events = await repository.getEventsByOrderId('ord-0142');
    expect(events.where((e) => e.toStatus == OrderStatus.siap), hasLength(1));
    await actions.advance('ord-0142', OrderStatus.diproses);
    expect((await repository.getOrderById('ord-0142'))!.status, OrderStatus.siap);
    expect(container.read(antreanActionsProvider).error, isNotNull);
  });
  test('reject removes proposal without cancelling its related order', () async {
    await container.read(antreanActionsProvider.notifier).reject('prop-001');
    final data = await container.read(antreanDataProvider.future);
    expect(data.chips.last, 'Perlu dicek 2');
    expect(data.orders.singleWhere((o) => o.id == 'ord-0139').status, OrderStatus.menungguJemput);
  });
}
