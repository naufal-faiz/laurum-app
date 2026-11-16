import 'package:flutter/material.dart';
import 'package:laurum/core/services/data_refresh_failure.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AppDataRefresh extends StatelessWidget {
  const AppDataRefresh({
    required this.child,
    required this.onRefresh,
    this.hasScrollableChild = true,
    super.key,
  });

  final Widget child;
  final Future<void> Function() onRefresh;
  final bool hasScrollableChild;

  @override
  Widget build(BuildContext context) {
    final behavior = ScrollConfiguration.of(context);
    // Stable physics prevent ScrollConfiguration from replacing ScrollPosition
    // on every header/tab rebuild. Retain the native Android/iOS scroll feel.
    final physics = switch (behavior.getPlatform(context)) {
      TargetPlatform.iOS || TargetPlatform.macOS => const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(parent: RangeMaintainingScrollPhysics()),
      ),
      _ => const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(parent: RangeMaintainingScrollPhysics()),
      ),
    };
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      notificationPredicate: (notification) => notification.metrics.axis == Axis.vertical,
      onRefresh: () async {
        try {
          await onRefresh();
        } catch (error) {
          if (!context.mounted) return;
          final message = error is DataRefreshFailure
              ? error.message
              : DataRefreshFailure.failed.message;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(message)));
        }
      },
      child: ScrollConfiguration(
        behavior: behavior.copyWith(physics: physics),
        child: hasScrollableChild
            ? child
            : LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: physics,
                  child: SizedBox(height: constraints.maxHeight, child: child),
                ),
              ),
      ),
    );
  }
}
