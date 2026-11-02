import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/auth/state/auth_error.dart';
import 'package:laurum/features/auth/state/auth_validation.dart';
import 'package:laurum/features/auth/state/password_reset_view.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

// Keep the cooldown across navigation; dispose cancels its timer.
final passwordResetProvider = NotifierProvider<PasswordReset, PasswordResetView>(PasswordReset.new);

class PasswordReset extends Notifier<PasswordResetView> {
  Timer? _timer;
  DateTime? _sentAt;
  int _ticks = 0;
  @override
  PasswordResetView build() {
    _timer?.cancel();
    _timer = null;
    _sentAt = null;
    _ticks = 0;
    ref.onDispose(() => _timer?.cancel());
    return const PasswordResetView();
  }

  void email(String value) {
    if (!state.busy) state = state.copyWith(email: value, sent: false);
  }

  int _remaining() => _sentAt == null
      ? 0
      : resetWaitSeconds(_sentAt!, ref.read(businessClockProvider)(), ticks: _ticks);
  void refreshCooldown() {
    state = state.copyWith(remaining: _remaining());
    if (state.remaining == 0) _timer?.cancel();
  }

  Future<bool> submit() async {
    if (state.busy || _remaining() > 0) return false;
    final error = authEmailError(state.email);
    if (error != null) {
      state = state.copyWith(emailError: error);
      return false;
    }
    state = state.copyWith(busy: true, sent: false);
    try {
      await ref.read(authServiceProvider).sendPasswordReset(state.email.trim().toLowerCase());
      if (!ref.mounted) return false;
      _sentAt = ref.read(businessClockProvider)();
      _ticks = 0;
      state = state.copyWith(busy: false, sent: true, remaining: 60);
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _ticks++;
        refreshCooldown();
      });
      return true;
    } catch (error) {
      if (ref.mounted) state = state.copyWith(busy: false, error: authErrorMessage(error));
      return false;
    }
  }
}
