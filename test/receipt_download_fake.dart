import 'dart:async';

import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/services/receipt_download_service.dart';

class FakeReceiptDownload implements ReceiptDownloadService {
  bool? result = true;
  int calls = 0;
  Completer<bool>? pending;
  ReceiptDocumentData? captured;
  @override
  Future<bool> save(ReceiptDocumentData data) async {
    calls++;
    captured = data;
    if (result == null) throw StateError('private path must never appear in UI');
    return pending?.future ?? Future.value(result!);
  }
}
