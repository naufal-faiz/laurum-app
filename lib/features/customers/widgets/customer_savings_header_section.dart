import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_savings_data.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';

class CustomerSavingsHeaderSection extends ConsumerWidget {
  const CustomerSavingsHeaderSection({required this.data, super.key});
  final CustomerSavingsData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = data.summary.customer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.cardGap,
            children: [
              Row(
                children: [
                  AppAvatar(initials: customerInitials(customer.name)),
                  const SizedBox(width: AppSpacing.cardGap),
                  Expanded(child: AppText(customer.name, variant: AppTextVariant.section)),
                ],
              ),
              AppText(Formatters.telepon(customer.phone), variant: AppTextVariant.caption),
              if (customer.isActive)
                const AppStatusText('Pelanggan Aktif', variant: AppStatusTextVariant.lunas)
              else
                const BannerMessage(message: 'Pelanggan nonaktif. Riwayat tetap tersimpan.'),
            ],
          ),
        ),
        StatTile(label: 'Saldo tabungan saat ini', value: Formatters.rupiah(data.summary.savings)),
        const AppText(
          'Titipan saldo dapat langsung memotong tagihan nota berikutnya secara otomatis di kasir.',
          variant: AppTextVariant.caption,
        ),
        AppButton(
          '+ Setor tabungan baru',
          onPressed: customer.isActive
              ? () => context.push('/pelanggan/${customer.id}/setor')
              : null,
        ),
        const SectionHeader(
          title: 'Riwayat mutasi',
          subtitle: 'Catatan mutasi tidak dapat diubah',
        ),
      ],
    );
  }
}
