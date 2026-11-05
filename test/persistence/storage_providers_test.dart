import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/persistence/account_storage.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/fake_auth_account.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

void main() {
  test('actual provider session switches owners, resets drafts and reopens prior data', () async {
    final dir = await Directory.systemTemp.createTemp('laurum-b1f-provider-');
    final auth = FakeAuthService(
      userId: 'account-a',
      email: 'a@example.test',
      accounts: const [
        FakeAuthAccount(
          id: 'account-a',
          email: 'a@example.test',
          name: 'A',
          password: 'Password1!',
        ),
        FakeAuthAccount(
          id: 'account-b',
          email: 'b@example.test',
          name: 'B',
          password: 'Password2!',
        ),
      ],
    );
    final storage = AccountStorage(directory: () async => dir, participants: () => [auth]);
    final c = ProviderContainer(
      overrides: [
        ...driftRepositoryOverrides(auth: auth),
        accountStorageProvider.overrideWithValue(storage),
      ],
    );
    final sub = c.listen(accountStoreProvider, (_, _) {});
    addTearDown(() async {
      sub.close();
      c.dispose();
      await storage.close();
      await dir.delete(recursive: true);
    });
    final a = (await c.read(accountStoreProvider.future))!;
    final originalGenerator = c.read(orderNumberGeneratorProvider);
    expect(await a.customers.getCustomers(), isEmpty); // Only demo owner may be seeded.
    await a.customers.saveCustomer(
      Customer(id: 'customer-a', ownerId: 'account-a', createdAt: DateTime(2026), name: 'A'),
    );
    c.read(transactionDraftProvider.notifier).selectCustomer('customer-a');
    final session = c.read(authSessionProvider.notifier);
    expect(await session.signOut(), isTrue);
    expect(await c.read(accountStoreProvider.future), isNull);
    expect(c.read(transactionDraftProvider).isEmpty, isTrue);
    expect(await session.signInWithPassword('b@example.test', 'Password2!'), isTrue);
    final b = (await c.read(accountStoreProvider.future))!;
    expect(c.read(orderNumberGeneratorProvider), isNot(same(originalGenerator)));
    expect(
      c.read(orderNumberGeneratorProvider).settings,
      same(c.read(localSettingsRepositoryProvider)),
    );
    expect(b.ownerId, 'account-b');
    expect(await b.customers.getCustomers(), isEmpty);
    expect(await session.signOut(), isTrue);
    await c.read(accountStoreProvider.future);
    expect(await session.signInWithPassword('a@example.test', 'Password1!'), isTrue);
    final again = (await c.read(accountStoreProvider.future))!;
    expect((await again.customers.getCustomers()).single.name, 'A');
    expect(c.read(localDataServiceProvider), same(again.localData));
    expect(c.read(transactionRunnerProvider), same(again.runner));
    expect(c.read(syncServiceProvider), same(again.sync));
    expect(await session.deleteAccount(), isTrue);
    await c.read(accountStoreProvider.future);
    expect(await File('${dir.path}/laurum_account-a.db').exists(), isFalse);
    expect(await File('${dir.path}/laurum_account-b.db').exists(), isTrue);
  });
}
