import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';

class ReceiptLinksSection extends StatelessWidget {
  const ReceiptLinksSection({required this.busy, required this.onOrder, this.onRecord, super.key});
  final bool busy;
  final VoidCallback onOrder;
  final VoidCallback? onRecord;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.cardGap,
    runSpacing: AppSpacing.small,
    children: [
      InlineLink('Lihat detail', onTap: busy ? null : onOrder),
      if (onRecord != null) InlineLink('Catat pembayaran', onTap: busy ? null : onRecord),
    ],
  );
}
