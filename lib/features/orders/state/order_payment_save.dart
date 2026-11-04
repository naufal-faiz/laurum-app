import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/payment_excess.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

Future<void> saveOrderPayment(
  Ref ref,
  String id, {
  required int received,
  required PayMethod method,
  bool saveExcess = false,
  bool completeOnPayment = false,
}) => ref.read(transactionRunnerProvider).run(() async {
  final repo = ref.read(orderRepositoryProvider);
  final order = await repo.getOrderById(id);
  if (order == null || order.status == OrderStatus.dibatalkan) throw StateError('Nota tidak aktif');
  final payments = await repo.getPaymentsByOrderId(id);
  final due = order.total - paidAmount(payments, orderId: id);
  if (received <= 0 ||
      due <= 0 ||
      method == PayMethod.tabungan ||
      (method != PayMethod.tunai && received > due)) {
    throw StateError('Nominal tidak valid');
  }
  final amount = received.clamp(0, due), extra = (received - due).clamp(0, received);
  final now = ref.read(businessClockProvider)();
  final paymentId = ref.read(idGeneratorProvider).newId();
  final profile = await ref.read(businessRepositoryProvider).getProfile();
  final complete =
      order.payTerm == PayTerm.cod &&
      amount == due &&
      order.status != OrderStatus.selesai &&
      (!profile.useOrderStatus || (completeOnPayment && order.status == OrderStatus.siap));
  final events = [
    OrderEvent(
      id: ref.read(idGeneratorProvider).newId(),
      ownerId: order.ownerId,
      createdAt: now,
      orderId: id,
      occurredAt: now,
      kind: 'payment',
    ),
  ];
  if (complete) {
    events.add(
      OrderEvent(
        id: ref.read(idGeneratorProvider).newId(),
        ownerId: order.ownerId,
        createdAt: now,
        orderId: id,
        occurredAt: now,
        kind: 'status',
        fromStatus: order.status,
        toStatus: OrderStatus.selesai,
      ),
    );
  }
  await repo.saveOrder(
    complete
        ? order.withStatus(OrderStatus.selesai, useOrderStatus: profile.useOrderStatus)
        : order,
    useOrderStatus: profile.useOrderStatus,
    payments: [
      Payment(
        id: paymentId,
        ownerId: order.ownerId,
        createdAt: now,
        orderId: id,
        method: method,
        amount: amount,
        received: received,
        paidAt: now,
      ),
    ],
    events: events,
  );
  if (method == PayMethod.tunai && saveExcess && extra > 0) {
    await ref
        .read(savingsRepositoryProvider)
        .addEntry(
          paymentExcess(
            order,
            paymentId: paymentId,
            amount: extra,
            at: now,
            ids: ref.read(idGeneratorProvider),
          ),
        );
  }
});
