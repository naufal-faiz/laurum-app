import 'package:laurum/core/domain/domain_record.dart';

class Expense extends DomainRecord {
  const Expense({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.categoryId,
    required this.amount,
    required this.spentAt,
    super.updatedAt,
    super.syncState,
    this.vendor = '',
    this.note = '',
    this.photoPath,
    this.deletedAt,
  }) : assert(amount >= 0);
  final String categoryId;
  final int amount;
  final DateTime spentAt;
  final String vendor;
  final String note;
  final String? photoPath;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [
    ...super.props,
    categoryId,
    amount,
    spentAt,
    vendor,
    note,
    photoPath,
    deletedAt,
  ];
}
