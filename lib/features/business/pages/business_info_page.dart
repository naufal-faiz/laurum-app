import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/business/pages/business_info_controller.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class BusinessInfoPage extends ConsumerWidget {
  const BusinessInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(businessInfoProvider);
    final state = async.value;
    return FormScaffold(
      title: 'Info usaha',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya'),
      footer: state == null
          ? const SizedBox.shrink()
          : AppButton(
              state.busy ? 'Menyimpan...' : 'Simpan',
              onPressed: state.busy ? null : () => ref.read(businessInfoProvider.notifier).save(),
            ),
      body: async.when(
        loading: () => const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [AppSkeleton(height: 88), AppSkeleton(height: 120), AppSkeleton(height: 88)],
        ),
        error: (_, _) => const EmptyState(
          title: 'Gagal memuat info usaha',
          icon: AppIcons.alert,
        ),
        data: (value) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            if (value.notice != null) BannerMessage(message: value.notice!),
            LabeledField(
              label: 'Nama usaha',
              errorText: value.nameError,
              child: AppTextField(
                label: 'Nama usaha',
                value: value.name,
                enabled: !value.busy,
                onChanged: ref.read(businessInfoProvider.notifier).setName,
              ),
            ),
            LabeledField(
              label: 'Alamat',
              child: AppTextField(
                label: 'Alamat',
                value: value.address,
                enabled: !value.busy,
                minLines: 2,
                maxLines: 2,
                onChanged: ref.read(businessInfoProvider.notifier).setAddress,
              ),
            ),
            LabeledField(
              label: 'Nomor telepon',
              helperText: 'Nomor telepon ditampilkan di struk.',
              child: AppTextField(
                label: 'Nomor telepon',
                value: value.phone,
                enabled: !value.busy,
                keyboardType: TextInputType.phone,
                onChanged: ref.read(businessInfoProvider.notifier).setPhone,
              ),
            ),
            LabeledField(
              label: 'Catatan kaki struk',
              helperText: 'Catatan tambahan struk diatur di layar Printer dan struk.',
              child: AppTextField(
                label: 'Catatan kaki struk',
                value: value.receiptFooter,
                enabled: !value.busy,
                minLines: 2,
                maxLines: 2,
                onChanged: ref.read(businessInfoProvider.notifier).setFooter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
