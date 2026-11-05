import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/persistence/demo_fixture_id.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';

List<Proposal> accountProposalFixtures(String ownerId) => [
  for (final p in proposalFixtures)
    Proposal(
      id: demoFixtureId(ownerId, p.id),
      ownerId: ownerId,
      createdAt: p.createdAt,
      status: p.status,
      sourceText: p.sourceText,
      customerId: p.customerId == null ? null : demoFixtureId(ownerId, p.customerId!),
      orderId: p.orderId == null ? null : demoFixtureId(ownerId, p.orderId!),
      serviceId: p.serviceId.isEmpty ? '' : demoFixtureId(ownerId, p.serviceId),
      customerName: p.customerName,
      phone: p.phone,
      address: p.address,
      cancelRequested: p.cancelRequested,
      uncertainAddress: p.uncertainAddress,
      deletedAt: p.deletedAt,
    ),
];
