import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

Payment _p(String id, String oId, PayMethod m, int amount, DateTime paidAt) => Payment(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: paidAt,
  orderId: oId,
  method: m,
  amount: amount,
  received: amount,
  paidAt: paidAt,
);

final paymentFixtures = <Payment>[
  _p('pay-115', 'ord-0115', PayMethod.tabungan, 25000, DateTime(2026, 10, 2, 14, 20)),
  _p('pay-127', 'ord-0127', PayMethod.tunai, 50000, DateTime(2026, 10, 14, 10)),
  _p('pay-128', 'ord-0128', PayMethod.transfer, 50000, DateTime(2026, 10, 11, 10)), // DP
  _p('pay-129', 'ord-0129', PayMethod.qris, 36000, DateTime(2026, 10, 14, 15)),
  _p('pay-130', 'ord-0130', PayMethod.tunai, 27000, DateTime(2026, 10, 15, 9)),
  _p('pay-139', 'ord-0139', PayMethod.tunai, 25000, DateTime(2026, 10, 16, 8, 30)),
  _p('pay-132', 'ord-0132', PayMethod.qris, 36000, DateTime(2026, 10, 16, 8, 30)),
  _p('pay-133', 'ord-0133', PayMethod.transfer, 30000, DateTime(2026, 10, 15, 11)),
  _p('pay-134', 'ord-0134', PayMethod.tunai, 20000, DateTime(2026, 10, 15, 14)),
  _p('pay-135', 'ord-0135', PayMethod.transfer, 45000, DateTime(2026, 10, 15, 16)),
  _p('pay-136', 'ord-0136', PayMethod.qris, 50000, DateTime(2026, 10, 14, 13)), // DP
  _p('pay-137', 'ord-0137', PayMethod.tunai, 28000, DateTime(2026, 10, 16, 7, 45)),
  _p('pay-140', 'ord-0140', PayMethod.tunai, 10000, DateTime(2026, 10, 16, 9, 15)), // DP
  _p('pay-141', 'ord-0141', PayMethod.tunai, 31500, DateTime(2026, 10, 16, 9, 50)),
];
