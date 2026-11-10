import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:lottie/lottie.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = AppDimensions.loader, this.label = 'Sedang memuat'});
  final double size;
  final String label;

  @override
  Widget build(BuildContext context) {
    final animate =
        !MediaQuery.disableAnimationsOf(context) && TickerMode.valuesOf(context).enabled;
    return Semantics(
      label: label,
      liveRegion: true,
      child: ExcludeSemantics(
        child: Lottie.asset(
          'assets/animations/laurum-loader.json',
          width: size,
          height: size,
          fit: BoxFit.contain,
          animate: animate,
          controller: animate ? null : const AlwaysStoppedAnimation<double>(0.5),
          frameRate: FrameRate.composition,
          errorBuilder: (_, error, stackTrace) => AppIcon(
            AppIcons.queue,
            size: size,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
