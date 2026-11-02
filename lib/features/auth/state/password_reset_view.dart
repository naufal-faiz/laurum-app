class PasswordResetView {
  const PasswordResetView({
    this.email = '',
    this.busy = false,
    this.sent = false,
    this.remaining = 0,
    this.emailError,
    this.error,
  });
  final String email;
  final bool busy, sent;
  final int remaining;
  final String? emailError, error;
  PasswordResetView copyWith({
    String? email,
    bool? busy,
    bool? sent,
    int? remaining,
    String? emailError,
    String? error,
  }) => PasswordResetView(
    email: email ?? this.email,
    busy: busy ?? this.busy,
    sent: sent ?? this.sent,
    remaining: remaining ?? this.remaining,
    emailError: emailError,
    error: error,
  );
}
