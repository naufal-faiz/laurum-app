import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/domain_record.dart';
import 'package:laurum/core/domain/order_rules.dart';

class Order extends DomainRecord {
  const Order({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.orderNo,
    required this.customerId,
    required this.status,
    required this.source,
    required this.discount,
    required this.enteredAt,
    required this.estimatedAt,
    required this.subtotal,
    required this.total,
    super.updatedAt,
    super.syncState,
    this.proposalId,
    this.note = '',
    this.deletedAt,
  }) : assert(discount >= 0),
       assert(subtotal >= discount),
       assert(total == subtotal - discount);
  final String orderNo;
  final String customerId;
  final OrderStatus status;
  final OrderSource source;
  final int discount;
  final DateTime enteredAt;
  final DateTime estimatedAt;
  final int subtotal;
  final int total;
  final String? proposalId;
  final String note;
  final DateTime? deletedAt;
  Order withStatus(OrderStatus value) {
    if (nextStatus(status, cancel: value == OrderStatus.dibatalkan) != value) {
      throw StateError('Invalid status transition');
    }
    return Order(
      id: id,
      ownerId: ownerId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      orderNo: orderNo,
      customerId: customerId,
      status: value,
      source: source,
      discount: discount,
      enteredAt: enteredAt,
      estimatedAt: estimatedAt,
      subtotal: subtotal,
      total: total,
      proposalId: proposalId,
      note: note,
      deletedAt: deletedAt,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    orderNo,
    customerId,
    status,
    source,
    discount,
    enteredAt,
    estimatedAt,
    subtotal,
    total,
    proposalId,
    note,
    deletedAt,
  ];
}
