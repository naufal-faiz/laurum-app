import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/persistence/account_storage.dart';

void main() {
  test('switch closes files, preserves data, isolates owners and deletes only own files', () async {
    final folder = await Directory.systemTemp.createTemp('laurum-b1f-');
    final storage = AccountStorage(directory: () async => folder);
    addTearDown(() async {
      await storage.close();
      await folder.delete(recursive: true);
    });
    final a = (await storage.activate('account-a'))!;
    await a.customers.saveCustomer(
      Customer(
        id: 'customer-a',
        ownerId: 'account-a',
        createdAt: DateTime(2026),
        name: 'Ratna',
      ),
    );
    await a.sync.refresh();
    expect(a.sync.pendingChanges, 1);
    await expectLater(
      a.runner.run(() async {
        await a.localData.deleteLocalData();
        throw StateError('injected outer rollback');
      }),
      throwsStateError,
    );
    await expectLater(a.localData.finishDelete(), throwsStateError);
    expect((await a.customers.getCustomers()).single.name, 'Ratna');
    expect(await File('${folder.path}/laurum_account-a.db').exists(), isTrue);
    await storage.activate(null);
    final b = (await storage.activate('account-b'))!;
    expect(await b.customers.getCustomers(), isEmpty);
    final again = (await storage.activate('account-a'))!;
    expect((await again.customers.getCustomers()).single.name, 'Ratna');
    expect(again.sync.pendingChanges, 1);
    await again.sync.syncNow();
    expect(again.sync.pendingChanges, 1); // B2 must acknowledge; never discard outbox.
    final photo = File('${folder.path}/expense_photos/account-a/photo.jpg');
    await photo.parent.create(recursive: true);
    await photo.writeAsString('photo');
    await again.localData.deleteLocalData();
    expect(await photo.exists(), isTrue); // Files only after SQL commit.
    await again.localData.finishDelete();
    expect(await photo.exists(), isFalse);
    expect(await File('${folder.path}/laurum_account-a.db').exists(), isFalse);
    expect(await File('${folder.path}/laurum_account-b.db').exists(), isTrue);
  });
}
