import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/in_memory_local_settings_repository.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/features/printer/state/printer_restore.dart';

void main() {
  Future<ProviderContainer> restoreWith(FakePrintService service) async {
    final settings = InMemoryLocalSettingsRepository();
    await settings.setString('printer_id', '66:32:A6:AE:A1:BF');
    await settings.setString('printer_name', 'Thermal 58');
    final container = ProviderContainer(
      overrides: [
        printServiceProvider.overrideWithValue(service),
        localSettingsRepositoryProvider.overrideWithValue(settings),
      ],
    );
    addTearDown(container.dispose);
    container.listen(printerRestoreProvider, (_, _) {});
    await container.read(printerRestoreProvider.future);
    return container;
  }

  test('reconnects the saved printer', () async {
    final service = FakePrintService();

    final container = await restoreWith(service);

    expect(service.status, PrintStatus.connected);
    expect(container.read(printerConnectionProvider).connected?.name, 'Thermal 58');
  });

  test('stays silent when bluetooth is off', () async {
    final service = FakePrintService(bluetoothOn: false);

    final container = await restoreWith(service);
    final state = container.read(printerConnectionProvider);

    expect(state.connected, isNull);
    expect(state.notice, isNull);
  });
}
