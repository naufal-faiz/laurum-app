import 'package:laurum/core/services/receipt_document_data.dart';

abstract class ExternalLauncher {
  Future<bool> launchWhatsApp({
    required String phone,
    required String message,
    ReceiptDocumentData? receipt,
  });
  Future<bool> launchUrl(String url);
}

class FakeExternalLauncher implements ExternalLauncher {
  final List<({String phone, String message})> whatsAppCalls = [];
  final List<String> launchedUrls = [];
  final List<ReceiptDocumentData?> whatsAppReceipts = [];
  bool shouldSucceed = true;

  @override
  Future<bool> launchWhatsApp({
    required String phone,
    required String message,
    ReceiptDocumentData? receipt,
  }) async {
    whatsAppCalls.add((phone: phone, message: message));
    whatsAppReceipts.add(receipt);
    return shouldSucceed;
  }

  @override
  Future<bool> launchUrl(String url) async {
    launchedUrls.add(url);
    return shouldSucceed;
  }
}
