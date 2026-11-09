import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const card = BorderRadius.all(Radius.circular(16));
  static const action = BorderRadius.all(Radius.circular(8));
  static const cta = BorderRadius.all(Radius.circular(14));
  static const secondary = cta;
  static const input = BorderRadius.all(Radius.circular(8));
  static const chip = BorderRadius.all(Radius.circular(999));
  static const badge = chip;
  static const sheet = BorderRadius.vertical(top: Radius.circular(28));
  static const numpad = BorderRadius.all(Radius.circular(12));
  static const modal = BorderRadius.all(Radius.circular(16));

  // Auth redesign (frame LAURUM · Masuk / · Daftar, FigCraft)
  static const authCard = BorderRadius.all(Radius.circular(24));
  static const authField = BorderRadius.all(Radius.circular(12));
  static const authBar = BorderRadius.all(Radius.circular(12));
  static const authLogo = BorderRadius.all(Radius.circular(12));
  static const authEye = BorderRadius.all(Radius.circular(9));
  static const authHero = BorderRadius.vertical(bottom: Radius.circular(32));
}
