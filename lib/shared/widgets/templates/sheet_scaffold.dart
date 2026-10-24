import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';

/// Content layout for [AppBottomSheet]: scrollable body and optional sticky footer.
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({
    required this.child,
    super.key,
    this.footer,
    this.padding = const EdgeInsets.all(AppSpacing.screenPadding),
  });

  final Widget child;
  final Widget? footer;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Flexible(
        child: SingleChildScrollView(padding: padding, child: child),
      ),
      if (footer != null)
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              AppSpacing.screenPadding,
            ),
            child: footer,
          ),
        ),
    ],
  );
}
