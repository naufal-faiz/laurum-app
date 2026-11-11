import 'package:file_saver/file_saver.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/services/receipt_pdf.dart';

abstract class ReceiptDownloadService {
  /// False means that the user cancelled the system save dialog.
  Future<bool> save(ReceiptDocumentData data);
}

class FileReceiptDownloadService implements ReceiptDownloadService {
  @override
  Future<bool> save(ReceiptDocumentData data) async {
    final bytes = await receiptPdf(data);
    final path = await FileSaver.instance.saveAs(
      name: data.fileName,
      bytes: bytes,
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
    return path != null && path.isNotEmpty;
  }
}
