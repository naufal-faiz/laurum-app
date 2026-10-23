import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/domain_record.dart';

class ServiceItem extends DomainRecord {
  const ServiceItem({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.name,
    required this.kind,
    required this.price,
    required this.durationDays,
    super.updatedAt,
    super.syncState,
    this.isActive = true,
    this.sortOrder = 0,
    this.deletedAt,
  }) : assert(price >= 0),
       assert(durationDays >= 0);
  final String name;
  final ServiceKind kind;
  final int price;
  final int durationDays;
  final bool isActive;
  final int sortOrder;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [
    ...super.props,
    name,
    kind,
    price,
    durationDays,
    isActive,
    sortOrder,
    deletedAt,
  ];
}
