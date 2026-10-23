import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order_number_generator.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  group('Data Dummy Integration Test', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(overrides: dummyRepositoryOverrides);
    });

    tearDown(() {
      container.dispose();
    });

    test('antrean aktif 12 order: 3 jemput, 5 proses, 4 siap', () async {
      final orderRepo = container.read(orderRepositoryProvider);
      final jemput = await orderRepo.getOrders(status: OrderStatus.menungguJemput);
      final proses = await orderRepo.getOrders(status: OrderStatus.diproses);
      final siap = await orderRepo.getOrders(status: OrderStatus.siap);

      expect(jemput.length, 3);
      expect(proses.length, 5);
      expect(siap.length, 4);
      expect(jemput.length + proses.length + siap.length, 12);
    });

    test('piutang tepat Rp400.500 dari 5 nota', () async {
      final totalOutstanding = outstanding(orderFixtures, paymentFixtures);
      expect(totalOutstanding, 400500);

      final piutangOrders = orderFixtures.where((o) {
        if (o.status == OrderStatus.dibatalkan) return false;
        final paid = paidAmount(paymentFixtures.where((p) => p.orderId == o.id));
        return paid < o.total;
      }).toList();

      expect(piutangOrders.length, 5);
      final nos = piutangOrders.map((o) => o.orderNo).toSet();
      expect(nos, {'A-0128', 'A-0136', 'A-0138', 'A-0140', 'A-0142'});
    });

    test('generator menghasilkan nomor nota berikutnya A-0143', () {
      const gen = OrderNumberGenerator();
      final next = gen.nextOrderNo(orderFixtures.map((o) => o.orderNo));
      expect(next, 'A-0143');
    });

    test('pelanggan total 48 orang dengan 5 punya piutang dan 5 tabungan', () {
      expect(customerFixtures.length, 48);
      final customerIdsWithSavings = savingsFixtures.map((s) => s.customerId).toSet();
      expect(customerIdsWithSavings.length, 5);
    });
  });
}
