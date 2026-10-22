import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

enum AppTextVariant {
  titleRoot,
  titleSub,
  section,
  figure,
  body,
  bodyStrong,
  input,
  label,
  caption,
  cta,
  monoLabel,
  monoReceipt;

  TextStyle get style => switch (this) {
    titleRoot => AppTextStyles.titleRoot,
    titleSub => AppTextStyles.titleSub,
    section => AppTextStyles.section,
    figure => AppTextStyles.figure,
    body => AppTextStyles.body,
    bodyStrong => AppTextStyles.bodyStrong,
    input => AppTextStyles.input,
    label => AppTextStyles.label,
    caption => AppTextStyles.caption,
    cta => AppTextStyles.cta,
    monoLabel => AppTextStyles.monoLabel,
    monoReceipt => AppTextStyles.monoReceipt,
  };
}

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color = AppColors.ink,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
  });

  final String data;
  final AppTextVariant variant;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) => Text(
    data,
    style: variant.style.copyWith(color: color),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    semanticsLabel: semanticsLabel,
  );
}
