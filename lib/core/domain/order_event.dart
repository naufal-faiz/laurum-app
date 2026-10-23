import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/domain_record.dart';

class OrderEvent extends DomainRecord {
  const OrderEvent({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.orderId,
    required this.occurredAt,
    required this.kind,
    super.updatedAt,
    super.syncState,
    this.note = '',
    this.fromStatus,
    this.toStatus,
    this.deletedAt,
  });
  final String orderId;
  final DateTime occurredAt;
  final String kind;
  final String note;
  final OrderStatus? fromStatus;
  final OrderStatus? toStatus;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [
    ...super.props,
    orderId,
    occurredAt,
    kind,
    note,
    fromStatus,
    toStatus,
    deletedAt,
  ];
}
