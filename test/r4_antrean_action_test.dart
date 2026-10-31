import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  test('disabled mode blocks stale queue callbacks without changing orders/events', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final business = scope.read(businessRepositoryProvider);
    await business.saveProfile((await business.getProfile()).withOrderStatus(enabled: false));
    final repo = scope.read(orderRepositoryProvider);
    final before = await repo.getOrderById('ord-0142');
    final events = await repo.getEventsByOrderId('ord-0142');
    await scope.read(antreanActionsProvider.notifier).advance('ord-0142', OrderStatus.diproses);
    expect(await repo.getOrderById('ord-0142'), before);
    expect(await repo.getEventsByOrderId('ord-0142'), events);
    expect(scope.read(antreanActionsProvider).pending, isEmpty);
    expect(scope.read(antreanActionsProvider).error, contains('Detail order'));
    await business.saveProfile((await business.getProfile()).withOrderStatus(enabled: true));
    await scope.read(antreanActionsProvider.notifier).advance('ord-0142', OrderStatus.diproses);
    expect((await repo.getOrderById('ord-0142'))!.status, OrderStatus.siap);
  });
}
