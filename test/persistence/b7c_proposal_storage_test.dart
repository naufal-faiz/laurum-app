import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/proposals/data/drift_proposal_repository.dart';
import 'package:laurum/features/proposals/data/in_memory_proposal_repository.dart';

import '../contracts/proposal_contract.dart';

void main() {
  late AppDatabase db;
  late OutboxWriter writer;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    writer = OutboxWriter(db, DriftTransactionRunner(db));
  });
  tearDown(() => db.close());

  group(
    'Drift Proposal contract',
    () => runProposalRepositoryContract(() => DriftProposalRepository(db, 'owner', writer)),
  );
  group('InMemory Proposal contract', () {
    late ProviderContainer scope;
    setUp(
      () =>
          scope = ProviderContainer(overrides: [proposalSeedProvider.overrideWithValue(const [])]),
    );
    tearDown(() => scope.dispose());
    runProposalRepositoryContract(
      () => scope.read(inMemoryProposalRepositoryProvider.notifier),
    );
  });

  group('Drift proposal decisions queue one sync change', () {
    late DriftProposalRepository repo;
    setUp(() {
      repo = DriftProposalRepository(db, 'owner', writer);
    });
    test('worker columns survive the decision and stay out of the payload', () async {
      await db
          .into(db.aiProposalRecords)
          .insert(
            AiProposalRecordsCompanion.insert(
              id: '10000000-0000-4000-8000-000000000001',
              ownerId: 'owner',
              createdAt: DateTime.utc(2026, 11, 18, 8),
              status: const Value('menunggu'),
              sourceText: const Value('Cuci 2 kg'),
              waMessageId: const Value('wam-1'),
              chatId: const Value('62812@c.us'),
              confidence: const Value(0.87),
              receivedAt: Value(DateTime.utc(2026, 11, 18, 8, 30)),
            ),
          );
      final p = (await repo.getProposalById('10000000-0000-4000-8000-000000000001'))!;
      await repo.saveProposal(p.withStatus(ProposalStatus.disetujui));
      final row = await db.select(db.aiProposalRecords).getSingle();
      expect(row.status, 'disetujui');
      expect(row.waMessageId, 'wam-1');
      final outbox = await db.select(db.outboxRecords).getSingle();
      expect(outbox.targetTable, 'ai_proposals');
      final payload = jsonDecode(outbox.payload) as Map<String, Object?>;
      expect(payload['status'], 'disetujui');
      expect(payload['wa_message_id'], 'wam-1');
      expect(payload.containsKey('sync_state'), isFalse);
      expect(payload.containsKey('decided_at'), isFalse);
      expect((await repo.getProposals(status: ProposalStatus.disetujui)), hasLength(1));
    });
  });
}
