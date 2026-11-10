import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

/// Blue primary button of the auth frames (50 dp, radius 14, trailing icon).
class AuthSubmitSection extends StatelessWidget {
  const AuthSubmitSection({
    required this.busy,
    required this.onSubmit,
    this.label = 'Masuk',
    this.icon = AppIcons.arrowForward,
    super.key,
  });

  final bool busy;
  final String label;
  final AppIcons icon;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) => AppButton(
    label,
    icon: icon,
    iconPlacement: AppButtonIconPlacement.trailing,
    busy: busy,
    onPressed: onSubmit,
  );
}
