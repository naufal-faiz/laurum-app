import 'package:laurum/core/services/auth_failure.dart';

String authErrorMessage(Object error) => switch (error) {
  AuthFailure(kind: AuthFailureKind.requestLimit) => 'Terlalu banyak percobaan. Coba lagi nanti',
  AuthFailure(kind: AuthFailureKind.currentPassword) =>
    'Password lama tidak cocok atau akun memakai Google.',
  AuthFailure(kind: AuthFailureKind.invalidInput) => 'Periksa kembali isian Anda.',
  _ => 'Tindakan gagal. Periksa koneksi dan coba lagi.',
};
