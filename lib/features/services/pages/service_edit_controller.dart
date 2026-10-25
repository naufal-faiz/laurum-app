import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/services/pages/service_copy.dart';
import 'package:laurum/features/services/pages/service_directory_data.dart';
import 'package:laurum/features/services/pages/service_edit_state.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';

final serviceEditProvider =
    AsyncNotifierProvider.family<ServiceEditController, ServiceEditState, String>(
      ServiceEditController.new,
    );

class ServiceEditController extends AsyncNotifier<ServiceEditState> {
  ServiceEditController(this.serviceId);
  final String serviceId;

  @override
  Future<ServiceEditState> build() async {
    if (serviceId.isEmpty) return const ServiceEditState();
    final service = await ref.read(serviceRepositoryProvider).getServiceById(serviceId);
    if (service == null) throw StateError('Layanan tidak ditemukan');
    return ServiceEditState(
      original: service,
      name: service.name,
      kind: service.kind,
      priceText: '${service.price}',
      durationDays: service.durationDays,
      isActive: service.isActive,
    );
  }

  void _edit(ServiceEditState Function(ServiceEditState) change) {
    final current = state.value;
    if (current != null) state = AsyncData(change(current));
  }

  void setName(String value) => _edit((s) => s.copyWith(name: value, clearErrors: true));
  void setKind(int index) =>
      _edit((s) => s.copyWith(kind: index == 0 ? ServiceKind.kiloan : ServiceKind.satuan));
  void setPrice(String value) => _edit((s) => s.copyWith(priceText: value, clearErrors: true));
  void setDuration(int days) => _edit((s) => s.copyWith(durationDays: days));
  void setActive({required bool value}) => _edit((s) => s.copyWith(isActive: value));

  Future<bool> save() async {
    final current = state.value;
    if (current == null || current.busy) return false;
    final name = current.name.trim();
    final price = current.price;
    if (name.isEmpty || price <= 0) {
      state = AsyncData(
        current.copyWith(
          nameError: name.isEmpty ? 'Nama layanan wajib diisi.' : null,
          priceError: price <= 0 ? 'Harga harus lebih dari Rp0.' : null,
        ),
      );
      return false;
    }
    state = AsyncData(current.copyWith(busy: true, clearNotice: true));
    final repository = ref.read(serviceRepositoryProvider);
    final now = ref.read(businessClockProvider)();
    try {
      final ServiceItem saved;
      if (current.original == null) {
        final all = await repository.getServices(includeInactive: true);
        saved = ServiceItem(
          id: 'srv-${DateTime.now().microsecondsSinceEpoch}',
          ownerId: ref.read(authServiceProvider).currentUserId ?? 'owner',
          createdAt: now,
          name: name,
          kind: current.kind,
          price: price,
          durationDays: current.durationDays,
          isActive: current.isActive,
          sortOrder: nextServiceSortOrder(all),
        );
      } else {
        saved = copyService(
          current.original!,
          name: name,
          kind: current.kind,
          price: price,
          durationDays: current.durationDays,
          isActive: current.isActive,
          updatedAt: now,
        );
      }
      await repository.saveService(saved);
      state = AsyncData(current.copyWith(busy: false));
      return true;
    } catch (_) {
      state = AsyncData(
        current.copyWith(busy: false, notice: 'Layanan gagal disimpan. Coba lagi.'),
      );
      return false;
    }
  }
}
