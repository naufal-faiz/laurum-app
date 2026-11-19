import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/domain/repositories/proposal_repository.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/proposals/data/proposal_storage_mapping.dart';

class DriftProposalRepository implements ProposalRepository {
  DriftProposalRepository(this.db, this.ownerId, this.writer, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now {
    if (!identical(db, writer.db)) throw ArgumentError('Outbox belongs to another database');
  }
  final AppDatabase db;
  final String ownerId;
  final OutboxWriter writer;
  final DateTime Function() clock;

  @override
  Future<List<Proposal>> getProposals({ProposalStatus? status}) async {
    final query = db.select(db.aiProposalRecords)
      ..where((r) => r.ownerId.equals(ownerId) & r.deletedAt.isNull())
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]);
    if (status != null) query.where((r) => r.status.equals(proposalStatusWire(status)));
    return List.unmodifiable((await query.get()).map(proposalFromRow));
  }

  @override
  Future<Proposal?> getProposalById(String id) async {
    final row =
        await (db.select(db.aiProposalRecords)..where(
              (r) => r.id.equals(id) & r.ownerId.equals(ownerId) & r.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    return row == null ? null : proposalFromRow(row);
  }

  @override
  Future<void> saveProposal(Proposal proposal) async {
    if (proposal.ownerId != ownerId) throw StateError('Proposal belongs to another account');
    final old = await (db.select(
      db.aiProposalRecords,
    )..where((r) => r.id.equals(proposal.id))).getSingleOrNull();
    if (old != null && old.ownerId != ownerId) {
      throw StateError('Proposal belongs to another account');
    }
    final at = clock();
    await writer.write(
      table: 'ai_proposals',
      rowId: proposal.id,
      payload: proposalPayload(proposal, old, at),
      mutate: () async {
        await db
            .into(db.aiProposalRecords)
            .insertOnConflictUpdate(
              proposalToRow(proposal, old, at),
            );
      },
    );
  }

  @override
  Future<void> updateProposalStatus(
    String id,
    ProposalStatus status, {
    String? orderId,
  }) async {
    final proposal = await getProposalById(id);
    if (proposal == null) throw StateError('Proposal not found');
    await saveProposal(proposal.withStatus(status, orderId: orderId));
  }
}
