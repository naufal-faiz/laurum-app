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
}
