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
    this.customerName = '',
    this.phone = '',
    this.address = '',
    this.serviceId = '',
    this.cancelRequested = false,
    this.uncertainAddress = false,
  });
  final ProposalStatus status;
  final String sourceText;
  final String? customerId;
  final String? orderId;
  final DateTime? deletedAt;
  final String customerName, phone, address, serviceId;
  final bool cancelRequested, uncertainAddress;
  Proposal withStatus(
    ProposalStatus value, {
    String? orderId,
    String? customerName,
    String? phone,
    String? address,
    String? serviceId,
  }) => Proposal(
    id: id,
    ownerId: ownerId,
    createdAt: createdAt,
    updatedAt: updatedAt,
    syncState: syncState,
    status: value,
    sourceText: sourceText,
    customerId: customerId,
    orderId: orderId ?? this.orderId,
    deletedAt: deletedAt,
    customerName: customerName ?? this.customerName,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    serviceId: serviceId ?? this.serviceId,
    cancelRequested: cancelRequested,
    uncertainAddress: uncertainAddress,
  );
  @override
  List<Object?> get props => [
    ...super.props,
    status,
    sourceText,
    customerId,
    orderId,
    deletedAt,
    customerName,
    phone,
    address,
    serviceId,
    cancelRequested,
    uncertainAddress,
  ];
}
