import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

Expense _e(
  String id,
  String catId,
  int amount,
  DateTime spentAt,
  String vendor,
  String note,
) => Expense(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: spentAt,
  categoryId: catId,
  amount: amount,
  spentAt: spentAt,
  vendor: vendor,
  note: note,
);

final weekExpenseFixtures = <Expense>[
  _e(
    'exp-018',
    'cat-001',
    110000,
    DateTime(2026, 10, 16, 10, 15),
    'Toko Surya Kimia',
    'deterjen cair Matic 2 jerigen (10 L)',
  ),
  _e(
    'exp-017',
    'cat-003',
    35000,
    DateTime(2026, 10, 16, 8, 40),
    '',
    'plastik jinjing HD 35 & 40 (2 pack)',
  ),
  _e('exp-016', 'cat-001', 85000, DateTime(2026, 10, 15, 14, 20), '', 'pewangi aroma sakura 5 L'),
  _e(
    'exp-015',
    'cat-002',
    620000,
    DateTime(2026, 10, 12, 9, 10),
    'PLN & PDAM',
    'token PLN dan PDAM',
  ),
];
