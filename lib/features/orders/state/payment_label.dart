import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/formatters/formatters.dart';

String paymentLabel(Order order, int paid) {
  final due = (order.total - paid).clamp(0, order.total);
  if (due == 0) return 'Lunas';
  final prefix = order.payTerm == PayTerm.cod ? 'COD - sisa' : 'Sisa';
  return '$prefix ${Formatters.rupiah(due)}';
}
