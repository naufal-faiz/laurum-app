import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/receipt_download_service.dart';
import 'package:laurum/features/transactions/state/receipt_document.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

typedef ReceiptDownloadState = ({bool busy, String? error, String? notice});
final receiptDownloadServiceProvider = Provider<ReceiptDownloadService>(
  (ref) => FileReceiptDownloadService(),
);
final receiptDownloadProvider = NotifierProvider.autoDispose<ReceiptDownload, ReceiptDownloadState>(
  ReceiptDownload.new,
);

class ReceiptDownload extends Notifier<ReceiptDownloadState> {
  @override
  ReceiptDownloadState build() => (busy: false, error: null, notice: null);

  Future<void> save(ReceiptView view) async {
    if (state.busy) return;
    state = (busy: true, error: null, notice: null);
    try {
      final saved = await ref.read(receiptDownloadServiceProvider).save(receiptDocument(view));
      if (ref.mounted) {
        state = (busy: false, error: null, notice: saved ? 'PDF struk tersimpan.' : null);
      }
    } on Object {
      if (ref.mounted) {
        state = (busy: false, error: 'Struk gagal diunduh. Silakan coba lagi.', notice: null);
      }
    }
  }
}
