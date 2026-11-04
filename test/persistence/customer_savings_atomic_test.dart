import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/customers/data/drift_customer_repository.dart';
import 'package:laurum/features/customers/data/drift_savings_repository.dart';

import '../contracts/customer_contract.dart';
import '../domain_samples.dart';

void main() {
  late AppDatabase db;
  late DriftCustomerRepository customers;
  late DriftSavingsRepository savings;
  final at = DateTime(2026, 11, 4, 12, 0, 0, 123, 456);
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    final writer = OutboxWriter(db, DriftTransactionRunner(db), clock: () => at);
    customers = DriftCustomerRepository(db, 'owner', writer, clock: () => at);
    savings = DriftSavingsRepository(db, 'owner', writer, clock: () => at);
  });
  tearDown(() => db.close());
  test('cannot attach savings to a customer owned by another account', () async {
    await db
        .into(db.customerRecords)
        .insert(
          CustomerRecordsCompanion.insert(
            id: 'foreign',
            ownerId: 'other',
            createdAt: at,
            name: 'Other',
          ),
        );
    await expectLater(
      savings.addEntry(
        SavingsEntry(
          id: 'a',
          ownerId: 'owner',
          createdAt: at,
          customerId: 'foreign',
          kind: SavingsKind.setor,
          amount: 100,
          method: PayMethod.tunai,
        ),
      ),
      throwsStateError,
    );
    expect(await savings.getAllEntries(), isEmpty);
    expect(await db.select(db.outboxRecords).get(), isEmpty);
  });
  test(
    'customer/outbox failure rolls back data; retry records local metadata and wire payload',
    () async {
      await db.customStatement('''CREATE TRIGGER fail_outbox BEFORE INSERT ON outbox
      BEGIN SELECT RAISE(ABORT, 'injected'); END''');
      await expectLater(customers.saveCustomer(contractCustomer('c')), throwsA(isA<Exception>()));
      expect(await customers.getCustomerById('c'), isNull);
      expect(await db.select(db.outboxRecords).get(), isEmpty);
      await db.customStatement('DROP TRIGGER fail_outbox');
      await customers.saveCustomer(contractCustomer('c'));
      final row = (await customers.getCustomerById('c'))!;
      expect(row.updatedAt, at);
      final outbox = await db.select(db.outboxRecords).getSingle();
      final payload = jsonDecode(outbox.payload) as Map<String, dynamic>;
      expect(payload['updated_at'], at.toUtc().toIso8601String());
      expect(payload.containsKey('phone_key'), isFalse);
      expect(payload.containsKey('name_key'), isFalse);
      expect(payload.containsKey('sync_state'), isFalse);
    },
  );
  test(
    'ledger retry does not duplicate outbox; failure and cross-owner writes leave no data',
    () async {
      await customers.saveCustomer(contractCustomer('c'));
      await savings.addEntry(saving('a'));
      await savings.addEntry(saving('a'));
      expect(await db.select(db.outboxRecords).get(), hasLength(2));
      final foreign = DriftCustomerRepository(db, 'other', customers.writer);
      expect(await foreign.getCustomers(), isEmpty);
      await expectLater(foreign.saveCustomer(contractCustomer('c')), throwsStateError);
      final otherSavings = DriftSavingsRepository(db, 'other', customers.writer);
      expect(await otherSavings.getBalance('c'), 0);
      expect(await otherSavings.getAllEntries(), isEmpty);
      await expectLater(otherSavings.addEntry(saving('a')), throwsStateError);
      await db.customStatement('''CREATE TRIGGER fail_ledger_outbox BEFORE INSERT ON outbox
      BEGIN SELECT RAISE(ABORT, 'injected'); END''');
      await expectLater(savings.addEntry(saving('b')), throwsA(isA<Exception>()));
      expect(await savings.getBalance('c'), 100);
      expect(await savings.getAllEntries(), hasLength(1));
      expect(await db.select(db.outboxRecords).get(), hasLength(2));
    },
  );
}
