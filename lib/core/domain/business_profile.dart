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
    this.deletedAt,
  });
  final String name;
  final String address;
  final String phone;
  final String receiptFooter;
  final String receiptNote;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [
    ...super.props,
    name,
    address,
    phone,
    receiptFooter,
    receiptNote,
    deletedAt,
  ];
}
