import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';

class ServiceEditState {
  const ServiceEditState({
    this.original,
    this.name = '',
    this.kind = ServiceKind.kiloan,
    this.priceText = '',
    this.durationDays = 2,
    this.isActive = true,
    this.nameError,
    this.priceError,
    this.busy = false,
    this.notice,
  });

  final ServiceItem? original;
  final String name;
  final ServiceKind kind;
  final String priceText;
  final int durationDays;
  final bool isActive;
  final String? nameError, priceError, notice;
  final bool busy;

  bool get isEdit => original != null;
  String get unitLabel => kind == ServiceKind.kiloan ? 'kg' : 'pcs';
  int get price => int.tryParse(priceText) ?? 0;

  ServiceEditState copyWith({
    String? name,
    ServiceKind? kind,
    String? priceText,
    int? durationDays,
    bool? isActive,
    String? nameError,
    String? priceError,
    bool? busy,
    String? notice,
    bool clearErrors = false,
    bool clearNotice = false,
  }) => ServiceEditState(
    original: original,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    priceText: priceText ?? this.priceText,
    durationDays: durationDays ?? this.durationDays,
    isActive: isActive ?? this.isActive,
    nameError: clearErrors ? null : nameError ?? this.nameError,
    priceError: clearErrors ? null : priceError ?? this.priceError,
    busy: busy ?? this.busy,
    notice: clearNotice ? null : notice ?? this.notice,
  );
}
