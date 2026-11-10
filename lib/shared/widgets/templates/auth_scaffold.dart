import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';

/// Auth screen frame: optional gradient [hero] behind a scrollable [child].
/// Without a hero it keeps the original padded form layout.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.child,
    super.key,
    this.hero,
    this.contentTop = 0,
    this.background = AppColors.bg,
  });

  final Widget child;
  final Widget? hero;
  final double contentTop;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: hero == null
            ? const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                96,
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
              )
            : EdgeInsets.only(top: contentTop, bottom: AppSpacing.xlarge),
        child: child,
      ),
    );
    return Scaffold(
      backgroundColor: background,
      body: hero == null ? content : Stack(children: [hero!, content]),
    );
  }
}
