import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

Order orderEditOrder(Order original, TransactionDraftState draft, DateTime now) => Order(
  id: original.id,
  ownerId: original.ownerId,
  createdAt: original.createdAt,
  updatedAt: now,
  orderNo: original.orderNo,
  customerId: original.customerId,
  status: original.status,
  source: original.source,
  discount: draft.discount,
  enteredAt: original.enteredAt,
  estimatedAt: estimateReady(original.enteredAt, draft.lines.map((line) => line.service)),
  subtotal: draft.subtotal,
  total: draft.total,
  note: draft.note,
  proposalId: original.proposalId,
);
