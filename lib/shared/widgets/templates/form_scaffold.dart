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
    this.subtitle,
    this.appBarVariant = AppBarSubVariant.standard,
    this.padding = const EdgeInsets.all(AppSpacing.screenPadding),
  });

  final String title, backLabel;
  final String? subtitle;
  final AppBarSubVariant appBarVariant;
  final Widget body, footer;
  final Widget? summary, trailing;
  final VoidCallback? onBack;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final detail = appBarVariant == AppBarSubVariant.detail;
    final header = AppBarSub(
      title: title,
      backLabel: backLabel,
      onBack: onBack,
      trailing: trailing,
      subtitle: detail && MediaQuery.viewInsetsOf(context).bottom > 0 ? null : subtitle,
      variant: appBarVariant,
    );
    final content = SingleChildScrollView(padding: padding, child: body);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: detail
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(AppSpacing.appBarHeight),
              child: header,
            ),
      body: detail
          ? Column(
              children: [
                header,
                Expanded(child: content),
              ],
            )
          : content,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: FooterBar(summary: summary, child: footer),
      ),
    );
  }
}
