import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

Customer _c(
  String id,
  String name,
  String phone, {
  String address = '',
  String notes = '',
}) => Customer(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: DateTime(2026),
  name: name,
  phone: phone,
  address: address,
  notes: notes,
);

final customerFixtures = <Customer>[
  _c(
    'cust-001',
    'Pak Dedi Budiarto',
    '0813-7788-1122',
    address: 'Jl. Cemara No. 12, RT 03/05',
    notes: '16 order, total Rp580.000; tabungan Rp50.000; piutang Rp31.500 (A-0142)',
  ),
  _c(
    'cust-002',
    'Bu Rina',
    '0812-8899-1234',
    address: 'Jl. Melati 4, depan Warung Bu Sri',
    notes: '14 order, Rp450.000; tabungan Rp18.500',
  ),
  _c(
    'cust-003',
    'Mbak Sari',
    '0877-6655-4433',
    address: 'Jl. Kemuning 12',
    notes: '6 order, Rp185.000; A-0140 DP Rp10.000, sisa Rp15.000',
  ),
  _c('cust-004', 'Budi Santoso', '0812-9876-5432', notes: '8 order, Rp230.000'),
  _c('cust-005', 'Pak Joko', '0856-1234-9090', notes: '22 order, Rp920.000'),
  _c('cust-006', 'Bu Linda Salon', '0813-8822-1190'),
  _c('cust-007', 'Pak Hendra', '0821-5566-7788'),
  _c('cust-008', 'Rian Katering', '0896-1234-5678'),
  _c('cust-009', 'Pak Rudi', '0819-1122-3344'),
  _c('cust-010', 'Agus Pratama', '0856-4400-1234'),
  _c('cust-011', 'Danang Kos Putri', '0857-2201-3344'),
  _c('cust-012', 'Mbak Maya Laundry', '0878-9900-1122'),
  _c('cust-013', 'Siti Rohmah', '0821-4455-6677'),
  ...List.generate(35, (index) {
    final num = index + 14;
    return _c(
      'cust-${num.toString().padLeft(3, '0')}',
      'Pelanggan $num',
      '0812-0000-${num.toString().padLeft(4, '0')}',
    );
  }),
];
