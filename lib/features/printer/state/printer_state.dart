import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/services/print_service.dart';

class PrinterConnectionState {
  const PrinterConnectionState({
    required this.status,
    this.devices = const [],
    this.connected,
    this.busy = false,
    this.notice,
    this.noticeError = false,
  });
  final PrintStatus status;
  final List<PrinterDevice> devices;
  final PrinterDevice? connected;
  final bool busy, noticeError;
  final String? notice;
  PrinterConnectionState copyWith({
    PrintStatus? status,
    List<PrinterDevice>? devices,
    PrinterDevice? connected,
    bool clearConnected = false,
    bool? busy,
    String? notice,
    bool? noticeError,
    bool clearNotice = false,
  }) => PrinterConnectionState(
    status: status ?? this.status,
    devices: devices ?? this.devices,
    connected: clearConnected ? null : connected ?? this.connected,
    busy: busy ?? this.busy,
    notice: clearNotice ? null : notice ?? this.notice,
    noticeError: noticeError ?? this.noticeError,
  );
}

ReceiptSettings copySettings(
  ReceiptSettings current, {
  int? paperMm,
  int? fontSize,
  bool? showAddress,
  bool? showCustomer,
  bool? showSavings,
  bool? showNote,
}) => ReceiptSettings(
  id: current.id,
  ownerId: current.ownerId,
  createdAt: current.createdAt,
  updatedAt: current.updatedAt,
  paperMm: paperMm ?? current.paperMm,
  fontSize: fontSize ?? current.fontSize,
  showAddress: showAddress ?? current.showAddress,
  showCustomer: showCustomer ?? current.showCustomer,
  showSavings: showSavings ?? current.showSavings,
  showNote: showNote ?? current.showNote,
);

BusinessProfile copyProfile(
  BusinessProfile current, {
  String? receiptFooter,
  String? receiptNote,
}) => BusinessProfile(
  id: current.id,
  ownerId: current.ownerId,
  createdAt: current.createdAt,
  updatedAt: current.updatedAt,
  name: current.name,
  address: current.address,
  phone: current.phone,
  receiptFooter: receiptFooter ?? current.receiptFooter,
  receiptNote: receiptNote ?? current.receiptNote,
  useOrderStatus: current.useOrderStatus,
);
