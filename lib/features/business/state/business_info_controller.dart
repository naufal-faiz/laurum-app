import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/business/state/business_info_state.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

final businessInfoProvider = AsyncNotifierProvider<BusinessInfoController, BusinessInfoState>(
  BusinessInfoController.new,
);

class BusinessInfoController extends AsyncNotifier<BusinessInfoState> {
  @override
  Future<BusinessInfoState> build() async {
    final profile = await ref.read(businessRepositoryProvider).getProfile();
    return BusinessInfoState(
      profile: profile,
      name: profile.name,
      address: profile.address,
      phone: profile.phone,
      receiptFooter: profile.receiptFooter,
    );
  }

  void _edit(BusinessInfoState Function(BusinessInfoState) change) {
    final current = state.value;
    if (current != null) state = AsyncData(change(current));
  }

  void setName(String value) => _edit((s) => s.copyWith(name: value, clearErrors: true));
  void setAddress(String value) => _edit((s) => s.copyWith(address: value));
  void setPhone(String value) => _edit((s) => s.copyWith(phone: value));
  void setFooter(String value) => _edit((s) => s.copyWith(receiptFooter: value));

  Future<bool> save() async {
    final current = state.value;
    if (current == null || current.busy) return false;
    final name = current.name.trim();
    if (name.isEmpty) {
      state = AsyncData(current.copyWith(nameError: 'Nama usaha wajib diisi.'));
      return false;
    }
    state = AsyncData(current.copyWith(busy: true, clearNotice: true));

    try {
      final profile = await ref.read(businessRepositoryProvider).getProfile();
      await ref
          .read(businessRepositoryProvider)
          .saveProfile(
            BusinessProfile(
              id: profile.id,
              ownerId: profile.ownerId,
              createdAt: profile.createdAt,
              updatedAt: ref.read(businessClockProvider)(),
              syncState: profile.syncState,
              name: name,
              address: current.address.trim(),
              phone: current.phone.trim(),
              receiptFooter: current.receiptFooter.trim(),
              receiptNote: profile.receiptNote,
              useOrderStatus: profile.useOrderStatus,
              deletedAt: profile.deletedAt,
            ),
          );
      state = AsyncData(current.copyWith(busy: false, notice: 'Info usaha disimpan.'));
      return true;
    } catch (_) {
      state = AsyncData(
        current.copyWith(busy: false, notice: 'Info usaha gagal disimpan. Coba lagi.'),
      );
      return false;
    }
  }
}
