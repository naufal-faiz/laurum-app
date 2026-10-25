import 'package:laurum/core/domain/business_profile.dart';

class BusinessInfoState {
  const BusinessInfoState({
    required this.profile,
    required this.name,
    required this.address,
    required this.phone,
    required this.receiptFooter,
    this.nameError,
    this.busy = false,
    this.notice,
  });

  final BusinessProfile profile;
  final String name, address, phone, receiptFooter;
  final String? nameError, notice;
  final bool busy;

  BusinessInfoState copyWith({
    String? name,
    String? address,
    String? phone,
    String? receiptFooter,
    String? nameError,
    bool? busy,
    String? notice,
    bool clearErrors = false,
    bool clearNotice = false,
  }) => BusinessInfoState(
    profile: profile,
    name: name ?? this.name,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    receiptFooter: receiptFooter ?? this.receiptFooter,
    nameError: clearErrors ? null : nameError ?? this.nameError,
    busy: busy ?? this.busy,
    notice: clearNotice ? null : notice ?? this.notice,
  );
}
