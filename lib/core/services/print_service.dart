abstract class PrintService {
  Future<bool> printReceipt(String text);
  bool get isConnected;
}

class FakePrintService implements PrintService {
  FakePrintService({this.isConnected = true});

  @override
  bool isConnected;
  final List<String> printedReceipts = [];

  @override
  Future<bool> printReceipt(String text) async {
    printedReceipts.add(text);
    return isConnected;
  }
}
