/// Session identity used by the UI; never contains tokens or passwords.
class AuthIdentity {
  const AuthIdentity({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.emailConfirmed,
    required this.usesPassword,
    required this.googleLinked,
  });
  final String id, email, name, phone;
  final bool emailConfirmed, usesPassword, googleLinked;
}
