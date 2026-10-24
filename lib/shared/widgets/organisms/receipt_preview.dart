import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/receipt_edge_clipper.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// Renders lines from [receiptLines]; it does not format the receipt itself.
class ReceiptPreview extends StatelessWidget {
  const ReceiptPreview({required this.lines, super.key, this.width = 320});

  final List<String> lines;
  final double width;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: width,
      child: ClipPath(
        clipper: const ReceiptEdgeClipper(),
        child: ColoredBox(
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in lines)
                  AppText(line, variant: AppTextVariant.monoReceipt, color: AppColors.receiptInk),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
