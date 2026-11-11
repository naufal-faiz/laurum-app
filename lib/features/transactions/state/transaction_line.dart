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
