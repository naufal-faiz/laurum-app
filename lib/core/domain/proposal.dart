import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/domain_record.dart';

class Proposal extends DomainRecord {
  const Proposal({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.status,
    required this.sourceText,
    super.updatedAt,
    super.syncState,
    this.customerId,
    this.orderId,
    this.deletedAt,
  });
  final ProposalStatus status;
  final String sourceText;
  final String? customerId;
  final String? orderId;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [...super.props, status, sourceText, customerId, orderId, deletedAt];
}
