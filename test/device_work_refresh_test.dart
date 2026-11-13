import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_import_data.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  test('customer writes remap imported contacts without reading the phone again', () async {
    final source = FakeContactSource(
      contacts: [
        const ContactItem(name: 'Pelanggan Impor', phone: '081234567890'),
      ],
    );
    final scope = ProviderContainer(overrides: dummyOverrides(contactSource: source));
    addTearDown(scope.dispose);
    scope.listen(contactImportProvider, (_, _) {});
    final initial = await scope.read(contactImportProvider.future);
    expect(initial.fresh, 1);
    await scope
        .read(customerRepositoryProvider)
        .saveCustomer(
          Customer(
            id: 'imported',
            ownerId: 'owner',
            createdAt: DateTime(2026),
            name: 'Pelanggan Impor',
            phone: '081234567890',
          ),
        );
    final updated = await scope.read(contactImportProvider.future);
    expect(updated.fresh, 0);
    expect(source.getContactsCallCount, 1);
  });

  test('leaving import discards the device snapshot for the next visit', () async {
    final source = FakeContactSource();
    final scope = ProviderContainer(overrides: dummyOverrides(contactSource: source));
    addTearDown(scope.dispose);
    final first = scope.listen(contactImportProvider, (_, _) {});
    await scope.read(contactImportProvider.future);
    first.close();
    await scope.pump();
    scope.listen(contactImportProvider, (_, _) {});
    await scope.read(contactImportProvider.future);
    expect(source.getContactsCallCount, 2);
  });

  test('permission failure is not retried until an explicit device refresh', () async {
    final source = FakeContactSource(permissionDenied: true);
    final scope = ProviderContainer(overrides: dummyOverrides(contactSource: source));
    addTearDown(scope.dispose);
    scope.listen(contactImportProvider, (_, _) {});
    await expectLater(
      scope.read(contactImportProvider.future),
      throwsA(isA<ContactPermissionDenied>()),
    );
    await scope.pump();
    expect(source.getContactsCallCount, 1);
    scope.invalidate(contactImportSourceProvider);
    await expectLater(
      scope.read(contactImportProvider.future),
      throwsA(isA<ContactPermissionDenied>()),
    );
    expect(source.getContactsCallCount, 2);
  });
}
