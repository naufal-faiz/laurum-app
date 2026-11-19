import 'package:drift/drift.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/persistence/app_database.dart';

String proposalStatusWire(ProposalStatus status) => switch (status) {
  ProposalStatus.menunggu => 'menunggu',
  ProposalStatus.disetujui => 'disetujui',
  ProposalStatus.ditolak => 'ditolak',
  ProposalStatus.ditutupOtomatis => 'ditutup_otomatis',
};

ProposalStatus proposalStatusFromWire(String value) => switch (value) {
  'disetujui' => ProposalStatus.disetujui,
  'ditolak' => ProposalStatus.ditolak,
  'ditutup_otomatis' => ProposalStatus.ditutupOtomatis,
  _ => ProposalStatus.menunggu,
};

Proposal proposalFromRow(AiProposalRow r) => Proposal(
  id: r.id,
  ownerId: r.ownerId,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  syncState: RecordSyncState.values.byName(r.syncState),
  status: proposalStatusFromWire(r.status),
  sourceText: r.sourceText ?? '',
  customerName: r.customerName,
  phone: r.phone,
  address: r.address,
  serviceId: r.serviceId ?? '',
  customerId: r.customerId,
  orderId: r.orderId,
  deletedAt: r.deletedAt,
  cancelRequested: r.cancelRequested,
  uncertainAddress: r.uncertainAddress,
);

/// Worker columns (wa_message_id, chat_id, confidence, received_at) never come
/// from the app, so an existing row keeps them untouched.
AiProposalRecordsCompanion proposalToRow(Proposal p, AiProposalRow? old, DateTime at) =>
    AiProposalRecordsCompanion.insert(
      id: p.id,
      ownerId: p.ownerId,
      createdAt: p.createdAt,
      updatedAt: Value(at),
      syncState: const Value('pending'),
      status: Value(proposalStatusWire(p.status)),
      sourceText: Value(p.sourceText.isEmpty ? null : p.sourceText),
      customerName: Value(p.customerName),
      phone: Value(p.phone),
      address: Value(p.address),
      serviceId: Value(p.serviceId.isEmpty ? null : p.serviceId),
      customerId: Value(p.customerId),
      orderId: Value(p.orderId),
      deletedAt: Value(p.deletedAt),
      cancelRequested: Value(p.cancelRequested),
      uncertainAddress: Value(p.uncertainAddress),
      waMessageId: Value(old?.waMessageId),
      chatId: Value(old?.chatId),
      confidence: Value(old?.confidence),
      receivedAt: Value(old?.receivedAt),
    );

Map<String, Object?> proposalPayload(Proposal p, AiProposalRow? old, DateTime at) => {
  'id': p.id,
  'owner_id': p.ownerId,
  'created_at': p.createdAt.toUtc().toIso8601String(),
  'updated_at': at.toUtc().toIso8601String(),
  'deleted_at': p.deletedAt?.toUtc().toIso8601String(),
  'status': proposalStatusWire(p.status),
  'source_text': p.sourceText.isEmpty ? null : p.sourceText,
  'customer_name': p.customerName,
  'phone': p.phone,
  'address': p.address,
  'service_id': p.serviceId.isEmpty ? null : p.serviceId,
  'customer_id': p.customerId,
  'order_id': p.orderId,
  'cancel_requested': p.cancelRequested,
  'uncertain_address': p.uncertainAddress,
  'wa_message_id': old?.waMessageId,
  'chat_id': old?.chatId,
  'confidence': old?.confidence,
  'received_at': old?.receivedAt?.toUtc().toIso8601String(),
};
