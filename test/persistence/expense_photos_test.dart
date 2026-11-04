import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/expenses/data/drift_expense_repository.dart';
import 'package:laurum/features/expenses/data/expense_photo_store.dart';

void main() {
  late AppDatabase db;
  late Directory dir;
  late DriftExpenseRepository repo;
  late DriftTransactionRunner runner;
  late File source;
  final day = DateTime(2026, 10, 16);
  Expense entry(String id, String path) => Expense(
    id: id,
    ownerId: 'owner',
    createdAt: day,
    categoryId: 'cat',
    amount: 100,
    spentAt: day,
    photoPath: path,
  );
  Future<List<FileSystemEntity>> photos() =>
      Directory('${dir.path}/app/expense_photos/owner').list().toList();
  setUp(() async {
    dir = await Directory.systemTemp.createTemp('laurum-b1e-photo-');
    source = await File('${dir.path}/picked.jpg').writeAsBytes([1, 2, 3]);
    db = AppDatabase(NativeDatabase.memory());
    runner = DriftTransactionRunner(db);
    repo = DriftExpenseRepository(
      db,
      'owner',
      OutboxWriter(db, runner),
      photos: ExpensePhotoStore('owner', directory: () async => Directory('${dir.path}/app')),
    );
    await repo.saveCategory(
      ExpenseCategory(id: 'cat', ownerId: 'owner', createdAt: day, name: 'Sabun'),
    );
  });
  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });
  test(
    'photo is copied into app storage and reused on edit; selected source is preserved',
    () async {
      await repo.saveExpense(entry('e', source.path));
      final path = (await repo.getExpenses()).single.photoPath!;
      expect(path, isNot(source.path));
      expect(await File(path).readAsBytes(), [1, 2, 3]);
      await repo.saveExpense(entry('e', path));
      expect(await photos(), hasLength(1));
      expect(await source.exists(), isTrue);
    },
  );
  test('failed outbox and failed outer transaction remove staged copies', () async {
    await db.customStatement(
      "CREATE TRIGGER fault BEFORE INSERT ON outbox BEGIN SELECT RAISE(ABORT, 'injected'); END",
    );
    await expectLater(repo.saveExpense(entry('e', source.path)), throwsA(anything));
    expect(await photos(), isEmpty);
    expect(await repo.getExpenses(), isEmpty);
    await db.customStatement('DROP TRIGGER fault');
    await expectLater(
      runner.run<void>(() async {
        await repo.saveExpense(entry('e', source.path));
        throw StateError('after photo write');
      }),
      throwsStateError,
    );
    expect(await photos(), isEmpty);
    expect(await repo.getExpenses(), isEmpty);
    expect(await db.select(db.outboxRecords).get(), hasLength(1));
    expect(await source.exists(), isTrue);
  });
}
