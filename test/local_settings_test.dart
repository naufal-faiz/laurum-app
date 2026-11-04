import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/order_number_generator.dart';
import 'package:laurum/core/services/in_memory_local_settings_repository.dart';
import 'package:laurum/core/services/in_memory_transaction_runner.dart';

import 'contracts/local_settings_contract.dart';

void main() {
  group('InMemory local settings contract', () {
    runLocalSettingsRepositoryContract(InMemoryLocalSettingsRepository.new);
  });
  test('counter continues highest fixture or saved counter, per device', () async {
    final settings = InMemoryLocalSettingsRepository();
    final numbers = OrderNumberGenerator(settings: settings);
    expect(await numbers.reserveOrderNo(['A-0142', 'B-0999']), 'A-0143');
    expect(await settings.getInt('order_counter_A'), 143);
    expect(await numbers.reserveOrderNo([]), 'A-0144');
    await settings.setString('device_code', 'B');
    expect(await numbers.reserveOrderNo(['A-0144', 'B-0002']), 'B-0003');
  });
  test('failed transaction restores counter; next retry reuses nota number', () async {
    final settings = InMemoryLocalSettingsRepository();
    final runner = InMemoryTransactionRunner(() => [settings]);
    final numbers = OrderNumberGenerator(settings: settings);
    await expectLater(
      runner.run(() async {
        expect(await numbers.reserveOrderNo(['A-0142']), 'A-0143');
        throw StateError('payment failed');
      }),
      throwsStateError,
    );
    expect(await settings.getInt('order_counter_A'), isNull);
    expect(await numbers.reserveOrderNo(['A-0142']), 'A-0143');
  });
}
