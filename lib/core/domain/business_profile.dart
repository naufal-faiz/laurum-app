import 'package:laurum/core/domain/domain_record.dart';

class BusinessProfile extends DomainRecord {
  const BusinessProfile({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.name,
    super.updatedAt,
    super.syncState,
    this.address = '',
    this.phone = '',
    this.receiptFooter = '',
    this.receiptNote = '',
    this.useOrderStatus = true,
    this.deletedAt,
  });
  final String name;
  final String address;
  final String phone;
  final String receiptFooter;
  final String receiptNote;
  final bool useOrderStatus;
  final DateTime? deletedAt;
  BusinessProfile withOrderStatus(bool value, {DateTime? updatedAt}) => BusinessProfile(
    id: id,
    ownerId: ownerId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncState: syncState,
    name: name,
    address: address,
    phone: phone,
    receiptFooter: receiptFooter,
    receiptNote: receiptNote,
    useOrderStatus: value,
    deletedAt: deletedAt,
  );
  @override
  List<Object?> get props => [
    ...super.props,
    name,
    address,
    phone,
    receiptFooter,
    receiptNote,
    useOrderStatus,
    deletedAt,
  ];
}
