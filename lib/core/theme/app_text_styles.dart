import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static const fontFamily = 'Plus Jakarta Sans';
  static const interFamily = 'Inter';
  static const numpad = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w700,
  );
  static const monoFamily = 'IBM Plex Mono';
  static const titleRoot = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
  );
  static const titleSub = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );
  static const section = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w600,
  );
  static const figure = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
  );
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );
  static const bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );
  static const input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );
  static const label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
  );
  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
  static const cta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w700,
  );
  static const monoLabel = TextStyle(
    fontFamily: monoFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
  static const monoReceipt = TextStyle(
    fontFamily: monoFamily,
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w400,
  );

  // Hero text styles (Inter, auth screens)
  static const heroTitle = TextStyle(
    fontFamily: interFamily,
    fontSize: 26,
    height: 32 / 26,
    fontWeight: FontWeight.w400,
  );
  static const heroTagline = TextStyle(
    fontFamily: interFamily,
    fontSize: 10,
    height: 16 / 10,
    fontWeight: FontWeight.w400,
  );
  static const heroLogo = TextStyle(
    fontFamily: interFamily,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w400,
  );
  static const heroLogoSub = TextStyle(
    fontFamily: interFamily,
    fontSize: 7,
    height: 12 / 7,
    fontWeight: FontWeight.w400,
  );
}
