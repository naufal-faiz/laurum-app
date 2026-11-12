enum AuthFormKind { signIn, signUp, password, recovery }

enum AuthSecret { password, confirmation, current }

// This view deliberately contains no password or token fields.
class AuthFormView {
  const AuthFormView({
    this.name = '',
    this.email = '',
    this.busy = false,
    this.visible = false,
    this.errors = const {},
    this.error,
    this.done = false,
  });
  final String name, email;
  final bool busy, visible, done;
  final Map<String, String> errors;
  final String? error;
  AuthFormView copyWith({
    String? name,
    String? email,
    bool? busy,
    bool? visible,
    Map<String, String>? errors,
    String? error,
    bool? done,
  }) => AuthFormView(
    name: name ?? this.name,
    email: email ?? this.email,
    busy: busy ?? this.busy,
    visible: visible ?? this.visible,
    errors: errors ?? this.errors,
    error: error,
    done: done ?? this.done,
  );
}
