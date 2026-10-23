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

final priorExpenseFixtures = <Expense>[
  _e(
    'exp-014',
    'cat-001',
    100000,
    DateTime(2026, 10, 11, 10),
    'Toko Kimia',
    'pemutih pakaian 10 L',
  ),
  _e('exp-013', 'cat-001', 75000, DateTime(2026, 10, 10, 11), 'Toko Kimia', 'pelembut pakaian'),
  _e('exp-012', 'cat-001', 60000, DateTime(2026, 10, 9, 9), 'Toko Kimia', 'sabun cuci piring'),
  _e('exp-011', 'cat-001', 80000, DateTime(2026, 10, 8, 14), 'Toko Kimia', 'sikat & spons cuci'),
  _e('exp-010', 'cat-001', 70000, DateTime(2026, 10, 7, 10), 'Toko Kimia', 'deterjen bubuk kiloan'),
  _e('exp-009', 'cat-001', 65000, DateTime(2026, 10, 6, 13), 'Toko Kimia', 'penghilang noda darah'),
  _e(
    'exp-008',
    'cat-001',
    55000,
    DateTime(2026, 10, 5, 11),
    'Toko Kimia',
    'penghilang noda minyak',
  ),
  _e('exp-007', 'cat-001', 50000, DateTime(2026, 10, 4, 15), 'Toko Kimia', 'pewangi lavender'),
  _e('exp-006', 'cat-001', 50000, DateTime(2026, 10, 3, 10), 'Toko Kimia', 'alkohol pembersih'),
  _e('exp-005', 'cat-001', 50000, DateTime(2026, 10, 2, 9), 'Toko Kimia', 'cuka pembersih'),
  _e(
    'exp-004',
    'cat-003',
    95000,
    DateTime(2026, 10, 10, 14),
    'Plastik Jaya',
    'hanger kawat 2 gross',
  ),
  _e(
    'exp-003',
    'cat-003',
    90000,
    DateTime(2026, 10, 8, 10),
    'Plastik Jaya',
    'plastik roll laundry',
  ),
  _e('exp-002', 'cat-003', 80000, DateTime(2026, 10, 5, 16), 'Plastik Jaya', 'isolasi & dispenser'),
  _e(
    'exp-001',
    'cat-003',
    80000,
    DateTime(2026, 10, 1, 10),
    'Plastik Jaya',
    'label kertas & tag gun',
  ),
];
