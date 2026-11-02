import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/state/auth_validation.dart';

final authFormProvider = NotifierProvider.autoDispose.family<AuthForm, AuthFormView, AuthFormKind>(
  AuthForm.new,
);

class AuthForm extends Notifier<AuthFormView> {
  AuthForm(this._kind);
  final AuthFormKind _kind;
  // Only transient field values, never part of state. Cleared with the form.
  String _password = '', _confirmation = '', _current = '';
  @override
  AuthFormView build() {
    ref.onDispose(_clearSecrets);
    return const AuthFormView();
  }

  void _clearSecrets() {
    _password = '';
    _confirmation = '';
    _current = '';
  }

  void name(String value) {
    if (!state.busy) state = state.copyWith(name: value, errors: {});
  }

  void email(String value) {
    if (!state.busy) state = state.copyWith(email: value, errors: {});
  }

  void clearError() {
    if (!state.busy) state = state.copyWith(errors: {});
  }

  void toggleVisible() {
    if (!state.busy) state = state.copyWith(visible: !state.visible);
  }

  void secret(AuthSecret field, String value) {
    if (state.busy) return;
    switch (field) {
      case AuthSecret.password:
        _password = value;
      case AuthSecret.confirmation:
        _confirmation = value;
      case AuthSecret.current:
        _current = value;
    }
    state = state.copyWith(errors: {});
  }

  Future<bool> submit() async {
    if (state.busy || ref.read(authSessionProvider).busy) return false;
    final errors = authFormErrors(
      _kind,
      name: state.name,
      email: state.email,
      password: _password,
      confirmation: _confirmation,
      current: _current,
    );
    if (errors.isNotEmpty) {
      state = state.copyWith(errors: errors);
      return false;
    }
    state = state.copyWith(busy: true, errors: {});
    final session = ref.read(authSessionProvider.notifier);
    final ok = await switch (_kind) {
      AuthFormKind.signIn => session.signInWithPassword(state.email, _password),
      AuthFormKind.signUp => session.signUp(state.email, _password, state.name),
      AuthFormKind.password => session.changePassword(_current, _password),
    };
    if (ok) _clearSecrets();
    if (ref.mounted) {
      state = state.copyWith(busy: false, error: ok ? null : ref.read(authSessionProvider).error);
    }
    return ok;
  }
}
