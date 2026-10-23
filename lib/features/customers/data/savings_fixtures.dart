import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

final savingsFixtures = <SavingsEntry>[
  // Pak Dedi Budiarto (cust-001)
  SavingsEntry(
    id: 'sav-001',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 9, 28, 16, 45),
    customerId: 'cust-001',
    kind: SavingsKind.setor,
    amount: 25000,
    method: PayMethod.tunai,
    note: 'Setoran tunai',
  ),
  SavingsEntry(
    id: 'sav-002',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 2, 14, 20),
    customerId: 'cust-001',
    kind: SavingsKind.pakai,
    amount: 25000,
    method: PayMethod.tabungan,
    orderId: 'ord-0115',
    note: 'Dipakai nota A-0115 (Bed cover)',
  ),
  SavingsEntry(
    id: 'sav-003',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 10, 9, 10),
    customerId: 'cust-001',
    kind: SavingsKind.setor,
    amount: 50000,
    method: PayMethod.tunai,
    note: 'Setoran tunai',
  ),

  // Bu Rina (cust-002) - saldo Rp18.500
  SavingsEntry(
    id: 'sav-004',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 8, 11),
    customerId: 'cust-002',
    kind: SavingsKind.setor,
    amount: 18500,
    method: PayMethod.tunai,
    note: 'Setoran awal',
  ),

  // Budi Santoso (cust-004) - saldo Rp100.000
  SavingsEntry(
    id: 'sav-005',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 9, 14),
    customerId: 'cust-004',
    kind: SavingsKind.setor,
    amount: 100000,
    method: PayMethod.transfer,
    note: 'Setoran tabungan',
  ),

  // Pak Joko (cust-005) - saldo Rp150.000
  SavingsEntry(
    id: 'sav-006',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 11, 10),
    customerId: 'cust-005',
    kind: SavingsKind.setor,
    amount: 150000,
    method: PayMethod.qris,
    note: 'Setoran tabungan',
  ),

  // Bu Linda Salon (cust-006) - saldo Rp111.500
  SavingsEntry(
    id: 'sav-007',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 12, 13, 30),
    customerId: 'cust-006',
    kind: SavingsKind.setor,
    amount: 111500,
    method: PayMethod.transfer,
    note: 'Setoran tabungan',
  ),
];
