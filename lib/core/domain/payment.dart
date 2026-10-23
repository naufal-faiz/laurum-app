import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/domain_record.dart';

class Payment extends DomainRecord {
  const Payment({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.orderId,
    required this.method,
    required this.amount,
    required this.received,
    required this.paidAt,
    super.updatedAt,
    super.syncState,
    this.note = '',
    this.deletedAt,
  });
  final String orderId;
  final PayMethod method;
  final int amount;
  final int received;
  final DateTime paidAt;
  final String note;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [
    ...super.props,
    orderId,
    method,
    amount,
    received,
    paidAt,
    note,
    deletedAt,
  ];
}
