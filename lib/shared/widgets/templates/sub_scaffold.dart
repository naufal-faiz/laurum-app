import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';

class SubScaffold extends StatelessWidget {
  const SubScaffold({
    required this.title,
    required this.backLabel,
    required this.body,
    super.key,
    this.onBack,
    this.trailing,
  });

  final String title, backLabel;
  final Widget body;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(AppSpacing.appBarHeight),
      child: AppBarSub(
        title: title,
        backLabel: backLabel,
        onBack: onBack,
        trailing: trailing,
      ),
    ),
    body: SafeArea(top: false, child: body),
  );
}
