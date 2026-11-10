import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';

/// White auth card: radius 24, card shadow, padding 18, 12 dp between children.
class AuthCard extends StatelessWidget {
  const AuthCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AppCard(
    style: AppCardStyle.elevated,
    padding: const EdgeInsets.all(AppSpacing.largeX),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.medium,
      children: children,
    ),
  );
}
