import 'package:flutter/material.dart';

/// IBM Plex Mono hanya untuk nomor nota, jam di kartu order, label grafik,
/// dan struk.
abstract final class AppMonoTextStyles {
  static const family = 'IBM Plex Mono';
  static const label = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
  static const receipt = TextStyle(
    fontFamily: family,
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w400,
  );
}
