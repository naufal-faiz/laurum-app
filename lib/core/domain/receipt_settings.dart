import 'package:laurum/core/domain/domain_record.dart';

class ReceiptSettings extends DomainRecord {
  const ReceiptSettings({
    required super.id,
    required super.ownerId,
    required super.createdAt,

    super.updatedAt,
    super.syncState,
    this.paperMm = 58,
    this.fontSize = 11,
    this.showAddress = true,
    this.showCustomer = true,
    this.showSavings = true,
    this.showNote = true,
    this.deletedAt,
  }) : assert(paperMm == 58 || paperMm == 80),
       assert(fontSize > 0);
  final int paperMm;
  final int fontSize;
  final bool showAddress;
  final bool showCustomer;
  final bool showSavings;
  final bool showNote;
  final DateTime? deletedAt;
  @override
  List<Object?> get props => [
    ...super.props,
    paperMm,
    fontSize,
    showAddress,
    showCustomer,
    showSavings,
    showNote,
    deletedAt,
  ];
}
