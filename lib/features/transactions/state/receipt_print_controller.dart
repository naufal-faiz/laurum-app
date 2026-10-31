import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

typedef ReceiptPrintState = ({bool printing, String? error, String? notice});

final receiptPrintProvider = NotifierProvider<ReceiptPrint, ReceiptPrintState>(
  ReceiptPrint.new,
);

class ReceiptPrint extends Notifier<ReceiptPrintState> {
  @override
  ReceiptPrintState build() => (printing: false, error: null, notice: null);

  void clearResult() {
    if (!state.printing) state = (printing: false, error: null, notice: null);
  }

  Future<bool> printReceipt(ReceiptView view) async {
    if (state.printing) return false;
    state = (printing: true, error: null, notice: null);
    var ok = false;
    try {
      ok = await ref
          .read(printServiceProvider)
          .printReceipt(
            ReceiptData(
              lines: view.lines,
              paperMm: view.settings.paperMm,
              fontSize: view.settings.fontSize,
            ),
          );
    } on Object {
      // Printer plugins may throw platform errors instead of returning false.
      ok = false;
    }
    state = (
      printing: false,
      error: ok ? null : 'Struk gagal dicetak. Pastikan printer menyala dan Bluetooth aktif.',
      notice: ok ? 'Struk terkirim ke printer.' : null,
    );
    return ok;
  }

  Future<void> sendWhatsApp(ReceiptView view) async {
    final ok = await ref
        .read(externalLauncherProvider)
        .launchWhatsApp(
          phone: view.customer.phone,
          message: view.lines.join('\n'),
        );
    state = (
      printing: false,
      error: ok ? null : 'Gagal membuka WhatsApp.',
      notice: ok ? 'Nota dikirim lewat WhatsApp.' : null,
    );
  }
}
