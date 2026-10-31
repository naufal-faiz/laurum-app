import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

typedef OrderStatusSettingState = ({bool saving, String? error});
final orderStatusSettingProvider = NotifierProvider<OrderStatusSetting, OrderStatusSettingState>(
  OrderStatusSetting.new,
);

class OrderStatusSetting extends Notifier<OrderStatusSettingState> {
  @override
  OrderStatusSettingState build() => (saving: false, error: null);

  Future<bool> setEnabled({required bool enabled}) async {
    if (state.saving) return false;
    state = (saving: true, error: null);
    try {
      final business = ref.read(businessRepositoryProvider);
      final current = await business.getProfile();
      await business.saveProfile(current.withOrderStatus(enabled: enabled));
      ref.invalidate(businessProfileProvider);
      ref.invalidate(receiptViewProvider);
      state = (saving: false, error: null);
      return true;
    } on Object {
      state = (saving: false, error: 'Gagal menyimpan pengaturan. Coba ubah sakelar lagi.');
      return false;
    }
  }
}
