import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

final proposalFixtures = <Proposal>[
  Proposal(
    id: 'prop-001',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 16, 8, 45),
    status: ProposalStatus.menunggu,
    sourceText: 'Pak, tolong batalkan pesanan cucian bed cover saya ya (A-0139)',
    customerId: 'cust-009',
    orderId: 'ord-0139',
    cancelRequested: true,
    customerName: 'Pak Rudi',
    serviceId: 'srv-004',
  ),
  Proposal(
    id: 'prop-002',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 16, 9, 12),
    status: ProposalStatus.menunggu,
    sourceText: 'Kak, besok pagi bisa diambil laundrynya? Cuci setrika aja, sekitar 3 kiloan. Alamat Jl. Melati 4 depan warung Bu Sri ya',
    customerId: 'cust-002',
    customerName: 'Bu Rina',
    phone: '0812-8899-1234',
    address: 'Jl. Melati 4, depan Warung Bu Sri',
    serviceId: 'srv-003',
    uncertainAddress: true,
  ),
  Proposal(
    id: 'prop-003',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 16, 10, 45),
    status: ProposalStatus.menunggu,
    sourceText: 'Halo, saya Agus. Saya ingin mencuci 1 bed cover. Bisa dibantu?',
    customerName: 'Agus Pratama',
    phone: '0856-4400-1234',
    serviceId: 'srv-004',
  ),
];

const proposalHistoryBaseline = {
  ProposalStatus.disetujui: 142,
  ProposalStatus.ditolak: 8,
  ProposalStatus.ditutupOtomatis: 3,
};
