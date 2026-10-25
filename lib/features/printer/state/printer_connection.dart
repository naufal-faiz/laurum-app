import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/printer/state/printer_state.dart';

final printerConnectionProvider =
    NotifierProvider<PrinterConnectionController, PrinterConnectionState>(
      PrinterConnectionController.new,
    );

class PrinterConnectionController extends Notifier<PrinterConnectionState> {
  @override
  PrinterConnectionState build() {
    final service = ref.watch(printServiceProvider);
    return PrinterConnectionState(
      status: service.status,
      connected: service.connectedPrinter,
    );
  }

  void _set(PrinterConnectionState Function(PrinterConnectionState current) change) =>
      state = change(state);

  Future<PrintStatus> discover() async {
    _set((s) => s.copyWith(busy: true, clearNotice: true));
    final service = ref.read(printServiceProvider);
    try {
      final devices = await service.discover();
      _set((s) => s.copyWith(devices: devices, status: service.status, busy: false));
    } on StateError {
      _set(
        (s) => s.copyWith(
          status: PrintStatus.bluetoothOff,
          busy: false,
          notice: 'Bluetooth mati. Aktifkan untuk mencari printer.',
          noticeError: true,
        ),
      );
    }
    return state.status;
  }

  Future<bool> connect(PrinterDevice device) async {
    _set((s) => s.copyWith(busy: true, clearNotice: true));
    final service = ref.read(printServiceProvider);
    final ok = await service.connect(device);
    _set(
      (s) => s.copyWith(
        status: service.status,
        connected: service.connectedPrinter,
        clearConnected: service.connectedPrinter == null,
        busy: false,
        notice: ok ? 'Terhubung ke ${device.name}.' : 'Gagal menghubungkan printer.',
        noticeError: !ok,
      ),
    );
    return ok;
  }

  Future<PrintStatus> testPrint(
    List<String> lines, {
    required int paperMm,
    required int fontSize,
  }) async {
    final service = ref.read(printServiceProvider);
    if (service.status != PrintStatus.connected || service.connectedPrinter == null) {
      return service.status;
    }
    final ok = await service.printReceipt(
      ReceiptData(lines: lines, paperMm: paperMm, fontSize: fontSize),
    );
    _set(
      (s) => s.copyWith(
        status: service.status,
        notice: ok ? 'Struk uji terkirim ke printer.' : 'Cetak gagal. Periksa printer.',
        noticeError: !ok,
      ),
    );
    return service.status;
  }

  Future<void> enableBluetooth() async {
    final service = ref.read(printServiceProvider);
    await service.enableBluetooth();
    _set((s) => s.copyWith(status: service.status, clearNotice: true));
  }
}
