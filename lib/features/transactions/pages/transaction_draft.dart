import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/formatters/formatters.dart';

class DraftLine {
  const DraftLine(this.service, this.qtyMilli);
  final ServiceItem service;
  final int qtyMilli;
  int get total => lineTotal(qtyMilli: qtyMilli, unitPrice: service.price);
  int get step => service.kind == ServiceKind.kiloan ? 500 : 1000;
  String get quantityLabel => service.kind == ServiceKind.kiloan
      ? Formatters.berat(qtyMilli)
      : Formatters.jumlah(qtyMilli ~/ 1000);
  String get priceLabel =>
      '${service.kind == ServiceKind.kiloan ? 'Kiloan' : 'Satuan'} · '
      '${Formatters.rupiah(service.price)}/${service.kind == ServiceKind.kiloan ? 'kg' : 'pcs'}';
}

class TransactionDraftState {
  const TransactionDraftState({
    this.customerId,
    this.lines = const [],
    this.discount = 0,
    this.note = '',
  });
  final String? customerId;
  final List<DraftLine> lines;
  final int discount;
  final String note;
  int get subtotal => lines.fold(0, (sum, line) => sum + line.total);
  int get total => subtotal - discount;
  int get itemCount => lines.length;
  bool get isEmpty => customerId == null && lines.isEmpty && discount == 0 && note.trim().isEmpty;
  DraftLine? lineFor(String serviceId) =>
      lines.where((line) => line.service.id == serviceId).firstOrNull;
}

class TransactionDraft extends Notifier<TransactionDraftState> {
  @override
  TransactionDraftState build() => const TransactionDraftState();
  void selectCustomer(String id) => state = TransactionDraftState(
    customerId: id,
    lines: state.lines,
    discount: state.discount,
    note: state.note,
  );

  void add(ServiceItem service) {
    final line = state.lineFor(service.id);
    if (line == null) {
      state = TransactionDraftState(
        customerId: state.customerId,
        lines: [...state.lines, DraftLine(service, 1000)],
        discount: state.discount,
        note: state.note,
      );
      return;
    }
    setQuantity(service.id, line.qtyMilli + line.step);
  }

  void setQuantity(String serviceId, int qtyMilli) {
    final line = state.lineFor(serviceId);
    if (line == null) return;
    final next = qtyMilli < line.step ? line.step : qtyMilli;
    state = TransactionDraftState(
      customerId: state.customerId,
      lines: [
        for (final item in state.lines)
          item.service.id == serviceId ? DraftLine(item.service, next) : item,
      ],
      discount: state.discount,
      note: state.note,
    );
  }

  void remove(String serviceId) => state = TransactionDraftState(
    customerId: state.customerId,
    lines: state.lines.where((line) => line.service.id != serviceId).toList(),
    discount: state.discount,
    note: state.note,
  );

  void setDiscount(int value) {
    if (value < 0 || value > state.subtotal) throw ArgumentError('Invalid discount');
    state = TransactionDraftState(
      customerId: state.customerId,
      lines: state.lines,
      discount: value,
      note: state.note,
    );
  }

  void setNote(String value) => state = TransactionDraftState(
    customerId: state.customerId,
    lines: state.lines,
    discount: state.discount,
    note: value,
  );

  void clear() => state = const TransactionDraftState();
}

int lineStep(ServiceItem service) => service.kind == ServiceKind.kiloan ? 500 : 1000;

final transactionDraftProvider = NotifierProvider<TransactionDraft, TransactionDraftState>(
  TransactionDraft.new,
);
