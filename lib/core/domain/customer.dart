import 'package:laurum/core/domain/domain_record.dart';

class Customer extends DomainRecord {
  const Customer({
    required super.id,
    required super.ownerId,
    required super.createdAt,
    required this.name,
    super.updatedAt,
    super.syncState,
    this.phone = '',
    this.address = '',
    this.notes = '',
    this.isActive = true,
    this.deletedAt,
  });
  final String name;
  final String phone;
  final String address;
  final String notes;
  final bool isActive;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [...super.props, name, phone, address, notes, isActive, deletedAt];
}
