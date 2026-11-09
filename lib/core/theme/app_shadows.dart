import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const appBar = [
    BoxShadow(color: Color(0x0A131B2E), offset: Offset(0, 1), blurRadius: 7),
  ];
  static const stepper = [
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 1.75),
  ];
  static const footer = [
    BoxShadow(color: Color(0x14131B2E), offset: Offset(0, -4), blurRadius: 14),
  ];
  // The C/Modal frames in laurum-ready.pen have no shadow effect.
  static const modal = <BoxShadow>[];

  static const cardElevated = [
    BoxShadow(color: Color(0x20174B83), offset: Offset(0, 14), blurRadius: 32),
  ];
  static const raised = [
    BoxShadow(color: Color(0x0D174B83), offset: Offset(0, 3), blurRadius: 10),
  ];
}
