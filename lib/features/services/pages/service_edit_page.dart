import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/state/service_edit_controller.dart';
import 'package:laurum/features/services/widgets/service_edit_fields_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class ServiceEditPage extends ConsumerWidget {
  const ServiceEditPage({super.key, this.serviceId = ''});
  final String serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(serviceEditProvider(serviceId));
    final state = async.value;
    return FormScaffold(
      title: serviceId.isEmpty ? 'Tambah layanan' : 'Edit layanan',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya/layanan'),
      footer: state == null
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.cardGap,
              children: [
                AppButton(
                  state.isEdit ? 'Simpan perubahan' : 'Simpan layanan',
                  onPressed: state.busy
                      ? null
                      : () async {
                          final saved = await ref
                              .read(serviceEditProvider(serviceId).notifier)
                              .save();
                          if (saved && context.mounted) context.pop();
                        },
                ),
                AppButton(
                  'Batal',
                  variant: AppButtonVariant.secondary,
                  onPressed: state.busy ? null : () => context.pop(),
                ),
              ],
            ),
      body: async.when(
        loading: () => const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [AppSkeleton(height: 320), AppSkeleton(height: 260)],
        ),
        error: (_, _) => const EmptyState(
          title: 'Layanan tidak ditemukan',
          icon: AppIcons.service,
        ),
        data: (value) => ServiceEditFieldsSection(state: value, serviceId: serviceId),
      ),
    );
  }
}
