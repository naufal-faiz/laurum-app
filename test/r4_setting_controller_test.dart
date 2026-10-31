import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/business/data/in_memory_business_repository.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/settings/state/order_status_setting.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/main_dummy.dart';

import 'r4_settings_test_support.dart';

void main() {
  test('toggle persists current profile and leaves orders/events/payments untouched', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final business = scope.read(businessRepositoryProvider);
    final initial = await scope.read(businessProfileProvider.future);
    final repo = scope.read(orderRepositoryProvider);
    final orders = await repo.getOrders();
    final events = await repo.getEventsByOrderId('ord-0142');
    final payments = await repo.getAllPayments();
    final controller = scope.read(orderStatusSettingProvider.notifier);
    expect(await controller.setEnabled(enabled: false), isTrue);
    expect(await business.getProfile(), initial.withOrderStatus(enabled: false));
    expect((await scope.read(businessProfileProvider.future)).useOrderStatus, isFalse);
    expect(await scope.read(orderActionsProvider.notifier).advance(orders.first), isFalse);
    expect(await repo.getOrders(), orders);
    expect(await repo.getEventsByOrderId('ord-0142'), events);
    expect(await repo.getAllPayments(), payments);
    expect(await controller.setEnabled(enabled: true), isTrue);
    expect(await business.getProfile(), initial);
  });

  test('busy rejects double toggle and storage failure can be retried', () async {
    final control = BusinessSaveControl()..gate = Completer<void>();
    final business = ControlledBusiness(control);
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        inMemoryBusinessRepositoryProvider.overrideWith(() => business),
      ],
    );
    addTearDown(scope.dispose);
    final controller = scope.read(orderStatusSettingProvider.notifier);
    final first = controller.setEnabled(enabled: false);
    expect(await controller.setEnabled(enabled: false), isFalse);
    expect(scope.read(orderStatusSettingProvider).saving, isTrue);
    control.fail = true;
    control.gate!.complete();
    expect(await first, isFalse);
    expect((await business.getProfile()).useOrderStatus, isTrue);
    expect(scope.read(orderStatusSettingProvider).error, isNotNull);
    expect(scope.read(orderStatusSettingProvider).saving, isFalse);
    control.fail = false;
    expect(await controller.setEnabled(enabled: false), isTrue);
    expect(control.saves, 2);
    expect(scope.read(orderStatusSettingProvider).error, isNull);
  });
}
