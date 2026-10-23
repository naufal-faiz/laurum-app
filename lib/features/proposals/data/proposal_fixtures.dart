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
  ),
  Proposal(
    id: 'prop-002',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 16, 9, 30),
    status: ProposalStatus.menunggu,
    sourceText: 'Bu Ratna, cucian saya tolong dipisah ya bajunya yang putih.',
    customerId: 'cust-004',
  ),
  Proposal(
    id: 'prop-003',
    ownerId: dummyOwnerId,
    createdAt: DateTime(2026, 10, 16, 10),
    status: ProposalStatus.menunggu,
    sourceText: 'Halo Berkah Laundry, mau tanya jemputan pakaian jam berapa ya?',
    customerId: 'cust-013',
  ),
];
