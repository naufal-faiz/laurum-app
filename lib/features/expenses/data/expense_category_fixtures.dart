import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

final expenseCategoryFixtures = <ExpenseCategory>[
  ExpenseCategory(
    id: 'cat-001',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026),
    name: 'Bahan cuci',
  ),
  ExpenseCategory(
    id: 'cat-002',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026),
    name: 'Listrik & air',
  ),
  ExpenseCategory(
    id: 'cat-003',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026),
    name: 'Kemasan',
  ),
  ExpenseCategory(
    id: 'cat-004',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026),
    name: 'Transport',
  ),
  ExpenseCategory(
    id: 'cat-005',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026),
    name: 'Lain-lain',
  ),
];
