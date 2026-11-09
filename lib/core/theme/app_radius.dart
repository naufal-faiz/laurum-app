import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const action = BorderRadius.all(Radius.circular(12));
  static const input = BorderRadius.all(Radius.circular(12));
  static const field = input;
  static const card = BorderRadius.all(Radius.circular(16));
  static const cardLarge = BorderRadius.all(Radius.circular(24));
  static const cta = BorderRadius.all(Radius.circular(14));
  static const secondary = cta;
  static const buttonSmall = BorderRadius.all(Radius.circular(12));
  static const bar = BorderRadius.all(Radius.circular(12));
  static const logo = BorderRadius.all(Radius.circular(12));
  static const hero = BorderRadius.vertical(bottom: Radius.circular(32));
  static const chip = BorderRadius.all(Radius.circular(999));
  static const badge = chip;
  static const sheet = BorderRadius.vertical(top: Radius.circular(28));
  static const numpad = BorderRadius.all(Radius.circular(12));
  static const modal = BorderRadius.all(Radius.circular(16));
}
