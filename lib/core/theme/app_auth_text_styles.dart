import 'package:flutter/material.dart';

/// Inter text styles for the auth redesign (frame LAURUM · Masuk / · Daftar).
/// Ukuran dinaikkan dari nilai frame agar ramah dibaca (revisi 9 Nov 2026);
/// proporsi dan hierarki tetap mengikuti frame.
abstract final class AppAuthTextStyles {
  static const family = 'Inter';

  // Hero
  static const heroTitle = TextStyle(
    fontFamily: family,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
  );
  static const heroBrand = TextStyle(
    fontFamily: family,
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w700,
  );
  static const heroBrandSub = TextStyle(
    fontFamily: family,
    fontSize: 9,
    height: 12 / 9,
    fontWeight: FontWeight.w600,
  );
  static const heroSub = TextStyle(
    fontFamily: family,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
  );

  // Card
  static const label = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
  );
  static const input = TextStyle(
    fontFamily: family,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );
  static const button = TextStyle(
    fontFamily: family,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
  static const bodyStrong = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
  );
  static const meta = TextStyle(
    fontFamily: family,
    fontSize: 11,
    height: 15 / 11,
    fontWeight: FontWeight.w400,
  );
  static const google = TextStyle(
    fontFamily: family,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );
  static const chip = TextStyle(
    fontFamily: family,
    fontSize: 10.5,
    height: 14 / 10.5,
    fontWeight: FontWeight.w600,
  );
}
