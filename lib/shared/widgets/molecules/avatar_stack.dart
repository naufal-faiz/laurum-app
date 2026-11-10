import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// Overlapping customer initials, up to three circles.
class AvatarStack extends StatelessWidget {
  const AvatarStack({required this.initials, super.key, this.size = 22});

  final List<String> initials;
  final double size;

  static const _backgrounds = [
    AppColors.primaryTint,
    AppColors.illustration,
    AppColors.primary,
  ];
  static const _foregrounds = [
    AppColors.primaryInk,
    AppColors.surface,
    AppColors.surface,
  ];

  @override
  Widget build(BuildContext context) {
    final visible = initials.take(3).toList();
    const overlap = 6.0;
    return SizedBox(
      width: visible.isEmpty ? 0 : size + (visible.length - 1) * (size - overlap),
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _backgrounds[i % _backgrounds.length],
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 1.5),
                ),
                child: SizedBox.square(
                  dimension: size,
                  child: Center(
                    child: AppText(
                      visible[i],
                      variant: AppTextVariant.label,
                      color: _foregrounds[i % _foregrounds.length],
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
