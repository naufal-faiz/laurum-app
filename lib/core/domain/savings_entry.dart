import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/domain_record.dart';

class SavingsEntry extends DomainRecord {
  const SavingsEntry({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.customerId,
    required this.kind,
    required this.amount,
    required this.method,
    super.updatedAt,
    super.syncState,
    this.orderId,
    this.note = '',
  }) : assert(kind == SavingsKind.penyesuaian || amount >= 0);
  final String customerId;
  final SavingsKind kind;
  final int amount;
  final PayMethod method;
  final String? orderId;
  final String note;
  @override
  List<Object?> get props => [...super.props, customerId, kind, amount, method, orderId, note];
}
