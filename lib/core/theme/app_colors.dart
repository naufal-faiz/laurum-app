import 'package:flutter/material.dart';

abstract final class AppColors {
  // Merek dan aksi
  static const primary = Color(0xFF2675C9);
  static const primaryInk = Color(0xFF174B83);
  static const primaryTint = Color(0xFFE3EEFA);
  static const onPrimary = Color(0xFFFFFFFF);

  // Status sukses (hijau lama)
  static const success = Color(0xFF2F7D4F);
  static const successTint = Color(0xFFE9F5EE);
  static const successInk = Color(0xFF1F6B41);

  // Teks
  static const ink = Color(0xFF26364A);
  static const ink2 = Color(0xFF4E5F76);
  static const ink3 = Color(0xFF7C8DA3);
  static const placeholder = Color(0xFFB7C2CF);

  // Permukaan
  static const bg = Color(0xFFF8F9FF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFF4F6F8);
  static const chipIdle = Color(0xFFF4F6F8);
  static const border = Color(0xFFE7EDF4);
  static const borderStrong = Color(0xFFDDE3E8);

  // Status
  static const error = Color(0xFFDC2626);
  static const errorInk = Color(0xFF9B1C1C);
  static const errorTint = Color(0xFFFEF2F2);
  static const warningBorder = Color(0xFFB45309);
  static const warningInk = Color(0xFF92400E);
  static const warningTint = Color(0xFFFFFDF5);
  static const slate = Color(0xFF475569);
  static const slateTint = Color(0xFFEEF1F5);
  static const slateInk = Color(0xFF334155);

  // Alias lama (pemakai dipindah pada lapisan berikutnya)
  static const blue = primaryInk;
  static const blueTint = primaryTint;
  static const blueInk = primary;

  // Dekorasi hero auth
  static const heroGradientStart = Color(0xFF2E7FD8);
  static const heroGradientEnd = Color(0xFF1B5FA3);
  static const heroTagline = Color(0xFFDCEBF9);
  static const heroBlob = Color(0x1AFFFFFF);
  static const heroBlobSoft = Color(0x14FFFFFF);
  static const heroDot = Color(0x80FFFFFF);
  static const illustration = Color(0xFF4A90DA);
  static const backBorder = Color(0xFF8FBCEB);

  // Merek pihak ketiga
  static const brandGoogleBlue = Color(0xFF4285F4);
  static const brandGoogleBorder = Color(0xFFE3E9F0);

  // Lain-lain
  static const brightAccent = Color(0xFFA0F5BE);
  static const scrim = Color(0x66131B2E);
  static const appBarBg = Color(0xD9F8F9FF);
  static const receiptInk = Color(0xFF000000);
}
