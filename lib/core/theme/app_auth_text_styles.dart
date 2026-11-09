import 'package:flutter/material.dart';

/// Inter text styles for the auth redesign (frame LAURUM · Masuk / · Daftar).
/// Sizes follow the FigCraft frame one-to-one.
abstract final class AppAuthTextStyles {
  static const family = 'Inter';

  // Hero
  static const heroTitle = TextStyle(
    fontFamily: family,
    fontSize: 26,
    height: 31 / 26,
    fontWeight: FontWeight.w700,
  );
  static const heroBrand = TextStyle(
    fontFamily: family,
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w700,
  );
  static const heroBrandSub = TextStyle(
    fontFamily: family,
    fontSize: 7,
    height: 8 / 7,
    fontWeight: FontWeight.w600,
  );
  static const heroSub = TextStyle(
    fontFamily: family,
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w400,
  );

  // Card
  static const label = TextStyle(
    fontFamily: family,
    fontSize: 8.5,
    height: 10 / 8.5,
    fontWeight: FontWeight.w600,
  );
  static const input = TextStyle(
    fontFamily: family,
    fontSize: 10.5,
    height: 13 / 10.5,
    fontWeight: FontWeight.w400,
  );
  static const button = TextStyle(
    fontFamily: family,
    fontSize: 11,
    height: 13 / 11,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(
    fontFamily: family,
    fontSize: 9,
    height: 11 / 9,
    fontWeight: FontWeight.w400,
  );
  static const bodyStrong = TextStyle(
    fontFamily: family,
    fontSize: 9,
    height: 11 / 9,
    fontWeight: FontWeight.w600,
  );
  static const meta = TextStyle(
    fontFamily: family,
    fontSize: 8.5,
    height: 10 / 8.5,
    fontWeight: FontWeight.w400,
  );
  static const google = TextStyle(
    fontFamily: family,
    fontSize: 10.5,
    height: 13 / 10.5,
    fontWeight: FontWeight.w600,
  );
  static const googleMark = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 15 / 12,
    fontWeight: FontWeight.w700,
  );
  static const chip = TextStyle(
    fontFamily: family,
    fontSize: 8,
    height: 10 / 8,
    fontWeight: FontWeight.w600,
  );
}
