import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/state/auth_validation.dart';

enum AccountField { name, phone }

typedef AccountEditView = ({String value, bool busy, String? error});
final accountEditProvider = NotifierProvider.autoDispose
    .family<AccountEdit, AccountEditView, AccountField>(AccountEdit.new);

class AccountEdit extends Notifier<AccountEditView> {
  AccountEdit(this._field);
  final AccountField _field;
  @override
  AccountEditView build() {
    final auth = ref.read(authServiceProvider);
    return (value: _field == AccountField.name ? auth.name : auth.phone, busy: false, error: null);
  }

  void start(String value) => state = (value: value, busy: false, error: null);
  void edit(String value) {
    if (!state.busy) state = (value: value, busy: false, error: null);
  }

  Future<bool> save() async {
    if (state.busy) return false;
    final error = _field == AccountField.name
        ? authNameError(state.value)
        : authPhoneError(state.value);
    if (error != null) {
      state = (value: state.value, busy: false, error: error);
      return false;
    }
    state = (value: state.value, busy: true, error: null);
    final auth = ref.read(authServiceProvider);
    final ok = await ref
        .read(authSessionProvider.notifier)
        .updateProfile(
          _field == AccountField.name ? state.value.trim() : auth.name,
          _field == AccountField.phone ? normalizeAuthPhone(state.value) : auth.phone,
        );
    if (ref.mounted) {
      state = (
        value: state.value,
        busy: false,
        error: ok ? null : ref.read(authSessionProvider).error,
      );
    }
    return ok;
  }
}
