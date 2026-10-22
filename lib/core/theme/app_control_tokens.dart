import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';

abstract final class AppControlTokens {
  static const ctaHeight = 56.0;
  static const iconGap = 8.0;
  static const avatarSize = 40.0;
  static const switchHeight = 28.0;
  static const switchThumb = 24.0;
  static const switchInset = 2.0;
  static const disabledOpacity = 0.5;
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 12);
  static const badgePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 2);
  static const switchPadding = EdgeInsets.all(switchInset);
  static const disabledForeground = AppColors.ink3;
}
