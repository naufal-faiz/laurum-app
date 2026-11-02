import 'package:laurum/core/services/auth_service.dart';

typedef AccountView = ({
  String name,
  String email,
  String phone,
  bool googleLinked,
  bool usesPassword,
});
AccountView accountView(AuthService auth) => (
  name: auth.name,
  email: auth.email,
  phone: auth.phone,
  googleLinked: auth.googleLinked,
  usesPassword: auth.usesPassword,
);
