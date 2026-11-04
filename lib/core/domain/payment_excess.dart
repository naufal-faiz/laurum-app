import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/savings_entry.dart';

SavingsEntry paymentExcess(
  Order order, {
  required String paymentId,
  required int amount,
  required DateTime at,
  IdGenerator ids = const IdGenerator(),
}) => SavingsEntry(
  id: ids.derived(paymentId, 'excess'),
  ownerId: order.ownerId,
  createdAt: at,
  customerId: order.customerId,
  kind: SavingsKind.setor,
  amount: amount,
  method: PayMethod.tunai,
  orderId: order.id,
  note: 'Kelebihan pembayaran $paymentId',
);
