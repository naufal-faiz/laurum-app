import 'package:laurum/core/domain/domain_record.dart';

class OrderItem extends DomainRecord {
  const OrderItem({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.orderId,
    required this.serviceId,
    required this.serviceName,
    required this.unit,
    required this.qtyMilli,
    required this.unitPrice,
    required this.lineTotal,
    super.updatedAt,
    super.syncState,
    this.deletedAt,
  }) : assert(qtyMilli >= 0),
       assert(unitPrice >= 0),
       assert(lineTotal >= 0);
  final String orderId;
  final String serviceId;
  final String serviceName;
  final String unit;
  final int qtyMilli;
  final int unitPrice;
  final int lineTotal;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [
    ...super.props,
    orderId,
    serviceId,
    serviceName,
    unit,
    qtyMilli,
    unitPrice,
    lineTotal,
    deletedAt,
  ];
}
