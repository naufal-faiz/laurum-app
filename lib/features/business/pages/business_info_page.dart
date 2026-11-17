import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/pages/account_flow.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/business/state/business_info_controller.dart';
import 'package:laurum/features/business/widgets/business_form_section.dart';
import 'package:laurum/features/business/widgets/business_note_section.dart';
import 'package:laurum/features/business/widgets/business_preview_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class BusinessInfoPage extends ConsumerWidget {
  const BusinessInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(businessInfoProvider);
    final state = async.value;
    final setup = ref.watch(authSessionProvider).needsSetup;
    final controller = ref.read(businessInfoProvider.notifier);
    return FormScaffold(
      title: 'Info usaha',
      subtitle: 'Data toko di struk & profil',
      backLabel: 'Kembali',
      appBarVariant: AppBarSubVariant.detail,
      onBack: setup
          ? () => confirmSignOut(context, ref)
          : () => context.canPop() ? context.pop() : context.go('/lainnya'),
      footer: state == null
          ? const SizedBox.shrink()
          : AppButton(
              state.busy ? 'Menyimpan...' : 'Simpan',
              onPressed: state.busy ? null : controller.save,
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
            BusinessPreviewSection(
              name: value.name,
              address: value.address,
              phone: value.phone,
              footer: value.receiptFooter,
            ),
            BusinessFormSection(
              name: value.name,
              address: value.address,
              phone: value.phone,
              footer: value.receiptFooter,
              nameError: value.nameError,
              busy: value.busy,
              onName: controller.setName,
              onAddress: controller.setAddress,
              onPhone: controller.setPhone,
              onFooter: controller.setFooter,
            ),
            const BusinessNoteSection(),
          ],
        ),
      ),
    );
  }
}
