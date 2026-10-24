import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/receipt_layout.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/formatters/formatters.dart';

const receiptColumns = ReceiptLayout.columns;

/// Thermal 58 mm receipt lines. Pure: preview and printer share this result.
List<String> receiptLines({
  required BusinessProfile business,
  required Order order,
  required List<OrderItem> items,
  required List<Payment> payments,
  required String customerName,
  required ReceiptSettings settings,
  int savingsBalance = 0,
}) {
  final active = items.where((i) => i.deletedAt == null).toList();
  final ledger = payments.where((p) => p.deletedAt == null).toList();
  final used = _sum(ledger, PayMethod.tabungan);
  final cash = ledger
      .where((p) => p.method != PayMethod.tabungan)
      .fold<int>(0, (sum, p) => sum + p.amount);
  final paid = used + cash;
  final due = (order.total - paid).clamp(0, order.total).toInt();
  final remaining = (savingsBalance - used).clamp(0, savingsBalance).toInt();
  return [
    ...ReceiptLayout.centered(business.name.toUpperCase()),
    if (settings.showAddress) ...ReceiptLayout.centered(business.address),
    if (business.phone.isNotEmpty) ...ReceiptLayout.centered('Telp ${business.phone}'),
    ReceiptLayout.rule,
    'No. Nota : ${order.orderNo}',
    'Tanggal  : ${Formatters.tanggalStruk(order.enteredAt)} ${Formatters.jam(order.enteredAt, struk: true)}',
    if (settings.showCustomer) 'Pelanggan: $customerName',
    ReceiptLayout.rule,
    for (final item in active) ...[
      ReceiptLayout.row(item.serviceName, Formatters.rupiah(item.lineTotal)),
      '  ${ReceiptLayout.quantity(item)} @ ${Formatters.rupiah(item.unitPrice)}',
    ],
    ReceiptLayout.rule,
    ReceiptLayout.row('TOTAL', Formatters.rupiah(order.total)),
    if (settings.showSavings && used > 0)
      ReceiptLayout.row('Tabungan dipakai', Formatters.rupiah(used)),
    for (final method in [PayMethod.tunai, PayMethod.qris, PayMethod.transfer])
      if (_sum(ledger, method) > 0)
        ReceiptLayout.row(
          'Dibayar ${_methodLabel(method)}',
          Formatters.rupiah(_sum(ledger, method)),
        ),
    ReceiptLayout.row('SISA BAYAR', Formatters.rupiah(due)),
    if (settings.showSavings && (savingsBalance > 0 || used > 0))
      ReceiptLayout.row('Sisa tabungan', Formatters.rupiah(remaining)),
    'STATUS: ${_status(due, paid, used, cash)}',
    ReceiptLayout.rule,
    if (settings.showNote && order.note.isNotEmpty) ...[
      ...ReceiptLayout.note(order.note),
      ReceiptLayout.rule,
    ],
    if (business.receiptFooter.isNotEmpty)
      ...ReceiptLayout.centeredBalanced(business.receiptFooter),
    if (business.receiptNote.isNotEmpty) ...ReceiptLayout.centeredBalanced(business.receiptNote),
  ];
}

int _sum(List<Payment> ledger, PayMethod method) =>
    ledger.where((p) => p.method == method).fold<int>(0, (sum, p) => sum + p.amount);

String _status(int due, int paid, int used, int cash) {
  if (due == 0) return used > 0 && cash == 0 ? 'LUNAS (TABUNGAN)' : 'LUNAS';
  return paid > 0 ? 'DP ${Formatters.rupiah(paid)}' : 'BELUM BAYAR';
}

String _methodLabel(PayMethod method) => switch (method) {
  PayMethod.tunai => 'tunai',
  PayMethod.qris => 'QRIS',
  PayMethod.transfer => 'transfer',
  PayMethod.tabungan => 'tabungan',
};
