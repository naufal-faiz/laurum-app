import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_deposit_controller.dart';
import 'package:laurum/features/customers/pages/customer_deposit_form_page.dart';
import 'package:laurum/features/customers/pages/customer_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class CustomerDepositPage extends ConsumerWidget {
  const CustomerDepositPage({required this.customerId, super.key});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(customerDetailProvider(customerId));
    final deposit = ref.watch(customerDepositProvider(customerId));
    final data = detail.value;
    return FormScaffold(
      title: 'Setor tabungan',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/pelanggan'),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          AppButton(
            'Simpan tabungan (${Formatters.rupiah(deposit.amount)})',
            onPressed: deposit.busy || data == null
                ? null
                : () async {
                    final saved = await ref
                        .read(customerDepositProvider(customerId).notifier)
                        .save();
                    if (saved && context.mounted) {
                      context.canPop() ? context.pop() : context.go('/pelanggan/$customerId');
                    }
                  },
          ),
          const AppText(
            'Tabungan tidak kedaluwarsa dan otomatis memotong nota transaksi berikutnya.',
            variant: AppTextVariant.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: detail.when(
        loading: () => const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [AppSkeleton(height: 240), AppSkeleton(height: 320)],
        ),
        error: (_, _) => EmptyState(
          title: 'Gagal memuat pelanggan',
          icon: AppIcons.alert,
          actionLabel: 'Coba lagi',
          onAction: () => ref.invalidate(customerDetailProvider(customerId)),
        ),
        data: (value) => value == null
            ? const EmptyState(title: 'Pelanggan tidak ditemukan', icon: AppIcons.person)
            : CustomerDepositFormPage(data: value),
      ),
    );
  }
}
