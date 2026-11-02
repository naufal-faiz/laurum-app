// Dummy credentials live in memory only; never expose them as UI state or logs.
class FakeAuthAccount {
  const FakeAuthAccount({
    required this.id,
    required this.email,
    this.name = '',
    this.phone = '',
    this.googleLinked = false,
    this.needsSetup = false,
    this._password,
  });
  final String id, email, name, phone;
  final bool googleLinked, needsSetup;
  final String? _password;
  bool matchesPassword(String value) => _password != null && _password == value;
  FakeAuthAccount copyWith({
    String? name,
    String? phone,
    String? password,
    bool? googleLinked,
    bool? needsSetup,
  }) => FakeAuthAccount(
    id: id,
    email: email,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    password: password ?? _password,
    googleLinked: googleLinked ?? this.googleLinked,
    needsSetup: needsSetup ?? this.needsSetup,
  );
}
