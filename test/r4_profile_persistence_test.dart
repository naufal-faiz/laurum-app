import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/business/state/business_info_controller.dart';
import 'package:laurum/features/printer/state/printer_settings.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  late ProviderContainer container;
  setUp(() => container = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => container.dispose());

  test('saving mode persists false without mutating orders or receipt settings', () async {
    final business = container.read(businessRepositoryProvider);
    final orders = container.read(orderRepositoryProvider);
    final before = await business.getProfile();
    final beforeOrders = await orders.getOrders();
    final beforeSettings = await business.getReceiptSettings();
    await business.saveProfile(before.withOrderStatus(false));
    expect((await business.getProfile()).useOrderStatus, isFalse);
    expect(await business.getReceiptSettings(), beforeSettings);
    expect(await orders.getOrders(), orderedEquals(beforeOrders));
    await business.saveProfile((await business.getProfile()).withOrderStatus(true));
    expect(await business.getProfile(), before);
  });

  test('business info save preserves latest mode changed after opening the form', () async {
    final opened = await container.read(businessInfoProvider.future);
    final business = container.read(businessRepositoryProvider);
    await business.saveProfile(opened.profile.withOrderStatus(false));
    final form = container.read(businessInfoProvider.notifier);
    form.setName('Berkah Laundry R4');
    expect(await form.save(), isTrue);
    final saved = await business.getProfile();
    expect(saved.useOrderStatus, isFalse);
    expect(saved.name, 'Berkah Laundry R4');
  });

  test('printer settings save does not restore status tracking to true', () async {
    final business = container.read(businessRepositoryProvider);
    await business.saveProfile((await business.getProfile()).withOrderStatus(false));
    await container.read(printerSettingsProvider.future);
    final printer = container.read(printerSettingsProvider.notifier);
    printer.edit(footer: 'Footer R4');
    await printer.save();
    final saved = await business.getProfile();
    expect(saved.useOrderStatus, isFalse);
    expect(saved.receiptFooter, 'Footer R4');
  });
}
