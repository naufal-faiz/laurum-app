import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/footer_bar.dart';

class FormScaffold extends StatelessWidget {
  const FormScaffold({
    required this.title,
    required this.backLabel,
    required this.body,
    required this.footer,
    super.key,
    this.summary,
    this.onBack,
    this.trailing,
    this.padding = const EdgeInsets.all(AppSpacing.screenPadding),
  });

  final String title, backLabel;
  final Widget body, footer;
  final Widget? summary, trailing;
  final VoidCallback? onBack;
  final EdgeInsetsGeometry padding;

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
    body: SingleChildScrollView(padding: padding, child: body),
    bottomNavigationBar: FooterBar(summary: summary, child: footer),
  );
}
