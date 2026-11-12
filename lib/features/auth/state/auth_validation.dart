import 'package:laurum/features/auth/state/auth_form_view.dart';

String? authNameError(String value) => value.trim().isEmpty ? 'Nama wajib diisi.' : null;
String? authEmailError(String value) => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())
    ? null
    : 'Masukkan email yang valid.';
String? authPasswordError(String value) =>
    value.runes.length >= 8 ? null : 'Password minimal 8 karakter.';
String? authConfirmationError(String password, String confirmation) =>
    password == confirmation ? null : 'Konfirmasi password tidak cocok.';
String normalizeAuthPhone(String value) => value.replaceAll(RegExp(r'[\s()-]'), '');
String? authPhoneError(String value) =>
    value.trim().isEmpty ||
        RegExp(r'^(08\d{8,11}|\+62\d{8,12})$').hasMatch(normalizeAuthPhone(value))
    ? null
    : 'Gunakan nomor 08xx atau +62 yang valid.';
int resetWaitSeconds(DateTime sent, DateTime now, {int ticks = 0}) {
  final clockSeconds = now.difference(sent).inSeconds;
  final elapsed = clockSeconds > ticks ? clockSeconds : ticks;
  return (60 - elapsed).clamp(0, 60);
}

Map<String, String> authFormErrors(
  AuthFormKind kind, {
  required String name,
  required String email,
  required String password,
  required String confirmation,
  required String current,
}) {
  final issues = <String, String?>{
    if (kind == AuthFormKind.signIn || kind == AuthFormKind.signUp) 'email': authEmailError(email),
    if (kind == AuthFormKind.signUp) 'name': authNameError(name),
    'password': kind == AuthFormKind.signIn
        ? (password.isEmpty ? 'Password wajib diisi.' : null)
        : authPasswordError(password),
    if (kind != AuthFormKind.signIn) 'confirmation': authConfirmationError(password, confirmation),
    if (kind == AuthFormKind.password)
      'current': current.isEmpty ? 'Password lama wajib diisi.' : null,
  };
  return {
    for (final entry in issues.entries)
      if (entry.value != null) entry.key: entry.value!,
  };
}
