enum PrintStatus { bluetoothOff, disconnected, connecting, connected, printing, error }

class PrinterDevice {
  const PrinterDevice({required this.id, required this.name});
  final String id, name;
}

class ReceiptData {
  const ReceiptData({
    required this.lines,
    required this.paperMm,
    required this.fontSize,
  }) : assert(paperMm == 58 || paperMm == 80),
       assert(fontSize > 0);
  final List<String> lines;
  final int paperMm, fontSize;
  String get text => lines.join('\n');
}

abstract class PrintService {
  PrintStatus get status;
  PrinterDevice? get connectedPrinter;
  Future<List<PrinterDevice>> discover();
  Future<bool> connect(PrinterDevice device);
  Future<bool> printReceipt(ReceiptData data);
  Future<bool> enableBluetooth();
  void disconnect();
}

class FakePrintService implements PrintService {
  FakePrintService({
    this.status = PrintStatus.disconnected,
    this.bluetoothOn = true,
    this.printSucceeds = true,
    List<PrinterDevice> devices = const [
      PrinterDevice(id: 'prn-58', name: 'Thermal 58mm'),
      PrinterDevice(id: 'prn-80', name: 'Thermal 80mm'),
    ],
  }) : devices = List.unmodifiable(devices);

  @override
  PrintStatus status;
  @override
  PrinterDevice? connectedPrinter;
  bool bluetoothOn, printSucceeds;
  final List<PrinterDevice> devices;
  final List<ReceiptData> printedReceipts = [];
  int discoverCalls = 0;

  @override
  Future<List<PrinterDevice>> discover() async {
    discoverCalls++;
    if (!bluetoothOn) {
      status = PrintStatus.bluetoothOff;
      throw StateError('Bluetooth is off');
    }
    if (status != PrintStatus.connected) status = PrintStatus.disconnected;
    return devices;
  }

  @override
  Future<bool> connect(PrinterDevice device) async {
    if (!bluetoothOn) {
      status = PrintStatus.bluetoothOff;
      return false;
    }
    status = PrintStatus.connected;
    connectedPrinter = device;
    return true;
  }

  @override
  Future<bool> printReceipt(ReceiptData data) async {
    if (status != PrintStatus.connected || connectedPrinter == null) {
      status = PrintStatus.disconnected;
      return false;
    }
    status = PrintStatus.printing;
    printedReceipts.add(data);
    status = printSucceeds ? PrintStatus.connected : PrintStatus.error;
    return printSucceeds;
  }

  @override
  Future<bool> enableBluetooth() async {
    bluetoothOn = true;
    if (status == PrintStatus.bluetoothOff) status = PrintStatus.disconnected;
    return true;
  }

  @override
  void disconnect() {
    status = PrintStatus.disconnected;
    connectedPrinter = null;
  }
}
