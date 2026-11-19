import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/domain/repositories/proposal_repository.dart';

import 'repository_factory.dart';

Proposal contractProposal(
  String id, {
  ProposalStatus status = ProposalStatus.menunggu,
  String sourceText = 'Cuci 2 kg',
}) => Proposal(
  id: id,
  ownerId: 'owner',
  createdAt: DateTime(2026, 11, 18, 8),
  status: status,
  sourceText: sourceText,
  customerName: 'Siti',
  phone: '081234567890',
  address: 'Jl. Mawar 1',
);

Proposal softDeleted(Proposal p, DateTime at) => Proposal(
  id: p.id,
  ownerId: p.ownerId,
  createdAt: p.createdAt,
  updatedAt: at,
  status: p.status,
  sourceText: p.sourceText,
  customerName: p.customerName,
  phone: p.phone,
  address: p.address,
  serviceId: p.serviceId,
  orderId: p.orderId,
  deletedAt: at,
);

void runProposalRepositoryContract(RepositoryFactory<ProposalRepository> factory) {
  late ProposalRepository repo;
  setUp(() async => repo = await factory());
  test('empty list and missing lookup', () async {
    expect(await repo.getProposals(), isEmpty);
    expect(await repo.getProposalById('missing'), isNull);
    expect(await repo.getProposals(status: ProposalStatus.menunggu), isEmpty);
  });
  test('save creates rows and status filters them', () async {
    await repo.saveProposal(contractProposal('p1'));
    await repo.saveProposal(contractProposal('p2', status: ProposalStatus.ditolak));
    expect((await repo.getProposals()).map((p) => p.id), unorderedEquals(['p1', 'p2']));
    expect((await repo.getProposals(status: ProposalStatus.menunggu)).map((p) => p.id), ['p1']);
    expect((await repo.getProposals(status: ProposalStatus.ditolak)).map((p) => p.id), ['p2']);
    expect(await repo.getProposals(status: ProposalStatus.disetujui), isEmpty);
  });
  test('status update keeps the message and stores the order', () async {
    await repo.saveProposal(contractProposal('p1'));
    await repo.updateProposalStatus('p1', ProposalStatus.disetujui, orderId: 'o1');
    final saved = (await repo.getProposalById('p1'))!;
    expect(saved.status, ProposalStatus.disetujui);
    expect(saved.orderId, 'o1');
    expect(saved.sourceText, 'Cuci 2 kg');
    expect(saved.customerName, 'Siti');
  });
  test('decision carries the owner edits', () async {
    await repo.saveProposal(contractProposal('p1'));
    final p = (await repo.getProposalById('p1'))!;
    await repo.saveProposal(
      p.withStatus(
        ProposalStatus.ditolak,
        customerName: 'Siti A',
        phone: '0813',
        address: 'Jl. Baru',
      ),
    );
    final saved = (await repo.getProposalById('p1'))!;
    expect(saved.status, ProposalStatus.ditolak);
    expect(saved.customerName, 'Siti A');
    expect(saved.phone, '0813');
    expect(saved.address, 'Jl. Baru');
    expect(saved.sourceText, 'Cuci 2 kg');
  });
  test('unknown id is not updatable', () async {
    await expectLater(
      repo.updateProposalStatus('missing', ProposalStatus.ditolak),
      throwsStateError,
    );
  });
  test('soft deleted rows disappear from reads', () async {
    await repo.saveProposal(contractProposal('gone'));
    final p = (await repo.getProposalById('gone'))!;
    await repo.saveProposal(softDeleted(p, DateTime(2026, 11, 18, 9)));
    expect(await repo.getProposalById('gone'), isNull);
    expect(await repo.getProposals(), isEmpty);
  });
}
