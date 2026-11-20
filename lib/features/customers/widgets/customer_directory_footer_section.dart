import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';

class CustomerDirectoryFooterSection extends StatelessWidget {
  const CustomerDirectoryFooterSection({
    required this.shown,
    required this.total,
    required this.onShowAll,
    super.key,
  });
  final int shown, total;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) => Row(
    spacing: AppSpacing.small,
    children: [
      Expanded(
        child: AppText('Menampilkan $shown dari $total pelanggan', variant: AppTextVariant.caption),
      ),
      if (shown < total) InlineLink('Lihat semua', onTap: onShowAll),
    ],
  );
}
