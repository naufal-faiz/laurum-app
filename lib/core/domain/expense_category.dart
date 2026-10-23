import 'package:laurum/core/domain/domain_record.dart';

class ExpenseCategory extends DomainRecord {
  const ExpenseCategory({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.name,
    super.updatedAt,
    super.syncState,
    this.isDefault = false,
    this.deletedAt,
  });
  final String name;
  final bool isDefault;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [...super.props, name, isDefault, deletedAt];
}
