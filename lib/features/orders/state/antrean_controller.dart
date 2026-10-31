import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

final antreanFilterProvider = NotifierProvider<AntreanFilter, int>(AntreanFilter.new);

class AntreanFilter extends Notifier<int> {
  @override
  int build() => 0;
  void select(int value) {
    if (value < 0 || value > 4) throw RangeError.range(value, 0, 4);
    state = value;
  }
}

typedef AntreanActionState = ({Set<String> pending, String? error});
final antreanActionsProvider = NotifierProvider<AntreanActions, AntreanActionState>(
  AntreanActions.new,
);

class AntreanActions extends Notifier<AntreanActionState> {
  @override
  AntreanActionState build() => (pending: const {}, error: null);
  Future<void> advance(String id, OrderStatus expected) async {
    if (state.pending.contains(id)) return;
    state = (pending: {...state.pending, id}, error: null);
    try {
      final profile = await ref.read(businessRepositoryProvider).getProfile();
      if (!profile.useOrderStatus) {
        state = (
          pending: state.pending,
          error: 'Pakai status order nonaktif. Selesaikan dari Detail order.',
        );
        return;
      }
      final repository = ref.read(orderRepositoryProvider);
      final order = await repository.getOrderById(id);
      if (order == null || order.status != expected) {
        throw StateError('Order changed; reload before advancing');
      }
      final next = nextStatus(order.status);
      final now = ref.read(businessClockProvider)();
      await repository.updateOrderStatus(
        id,
        next,
        event: OrderEvent(
          id: '$id-status-${next.name}',
          ownerId: order.ownerId,
          createdAt: now,
          orderId: id,
          occurredAt: now,
          kind: 'status',
          fromStatus: order.status,
          toStatus: next,
        ),
      );
      ref.invalidate(antreanDataProvider);
    } on Exception {
      state = (pending: state.pending, error: 'Gagal mengubah status. Coba lagi.');
    } on StateError {
      state = (pending: state.pending, error: 'Status order berubah. Muat ulang antrean.');
      ref.invalidate(antreanDataProvider);
    } finally {
      state = (pending: {...state.pending}..remove(id), error: state.error);
    }
  }

  Future<void> reject(String id) async {
    if (state.pending.contains(id)) return;
    state = (pending: {...state.pending, id}, error: null);
    try {
      await ref.read(proposalRepositoryProvider).updateProposalStatus(id, ProposalStatus.ditolak);
      ref.invalidate(antreanDataProvider);
    } on Exception {
      state = (pending: state.pending, error: 'Gagal menolak usulan. Coba lagi.');
    } finally {
      state = (pending: {...state.pending}..remove(id), error: state.error);
    }
  }
}
