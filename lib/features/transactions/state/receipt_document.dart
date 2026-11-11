import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/receipt_layout.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/features/orders/state/payment_label.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

ReceiptDocumentData receiptDocument(ReceiptView view) {
  final order = view.order, settings = view.settings, business = view.business;
  final ledger = view.payments.where((p) => p.deletedAt == null && p.orderId == order.id);
  final paid = paidAmount(ledger, orderId: order.id);
  final used = ledger.where((p) => p.method == PayMethod.tabungan).fold(0, (v, p) => v + p.amount);
  final due = (order.total - paid).clamp(0, order.total);
  final methods = {
    PayMethod.tunai: 'Tunai',
    PayMethod.qris: 'QRIS',
    PayMethod.transfer: 'Transfer',
  };
  return ReceiptDocumentData(
    title: business.name.toUpperCase(),
    header: [
      if (settings.showAddress && business.address.isNotEmpty) business.address,
      if (business.phone.isNotEmpty) Formatters.telepon(business.phone),
    ],
    groups: [
      [
        ReceiptDocumentRow('No. Nota', order.orderNo),
        ReceiptDocumentRow(
          'Tanggal',
          '${Formatters.tanggalStruk(order.enteredAt)} · ${Formatters.jam(order.enteredAt, struk: true)}',
        ),
        if (settings.showCustomer) ReceiptDocumentRow('Pelanggan', view.customer.name),
      ],
      [
        for (final item in view.items.where((i) => i.deletedAt == null))
          ReceiptDocumentRow(
            item.serviceName,
            Formatters.rupiah(item.lineTotal),
            detail: '${ReceiptLayout.quantity(item)} × ${Formatters.rupiah(item.unitPrice)}',
          ),
      ],
      [
        ReceiptDocumentRow('Subtotal', Formatters.rupiah(order.subtotal)),
        ReceiptDocumentRow('Diskon', Formatters.rupiah(order.discount)),
        ReceiptDocumentRow('TOTAL', Formatters.rupiah(order.total), emphasis: true),
        if (settings.showSavings && used > 0)
          ReceiptDocumentRow('Tabungan dipakai', Formatters.rupiah(used)),
        for (final method in methods.keys)
          if (ledger.any((p) => p.method == method && p.amount > 0))
            ReceiptDocumentRow(
              'Dibayar ${methods[method]}',
              Formatters.rupiah(
                ledger.where((p) => p.method == method).fold(0, (v, p) => v + p.amount),
              ),
            ),
        ReceiptDocumentRow('SISA BAYAR', Formatters.rupiah(due)),
        if (settings.showSavings && (view.savingsBalance > 0 || used > 0))
          ReceiptDocumentRow(
            'Sisa tabungan',
            Formatters.rupiah((view.savingsBalance - used).clamp(0, view.savingsBalance)),
          ),
      ],
    ],
    status: 'STATUS: ${paymentLabel(order, paid).toUpperCase()}',
    settled: due == 0,
    footer: [
      if (settings.showNote && order.note.isNotEmpty) 'Catatan: ${order.note}',
      if (business.receiptFooter.isNotEmpty) business.receiptFooter,
      if (business.receiptNote.isNotEmpty) business.receiptNote,
    ],
    fileName: 'struk-${order.orderNo.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}',
  );
}
