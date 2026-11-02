enum AuthFailureKind { requestLimit, currentPassword, invalidInput, unavailable }

class AuthFailure implements Exception {
  const AuthFailure(this.kind);
  final AuthFailureKind kind;
  @override
  String toString() => 'AuthFailure(${kind.name})';
}
