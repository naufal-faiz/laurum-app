import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/state/service_edit_controller.dart';
import 'package:laurum/features/services/widgets/service_form_footer_section.dart';
import 'package:laurum/features/services/widgets/service_form_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class ServiceEditPage extends ConsumerWidget {
  const ServiceEditPage({super.key, this.serviceId = ''});
  final String serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(serviceEditProvider(serviceId));
    final state = async.value;
    final creating = serviceId.isEmpty;
    final business = ref.watch(businessProfileProvider).value?.name;
    Future<void> save() async {
      final saved = await ref.read(serviceEditProvider(serviceId).notifier).save();
      if (saved && context.mounted) context.pop();
    }

    return FormScaffold(
      title: creating ? 'Tambah layanan' : 'Edit layanan',
      backLabel: 'Kembali',
      subtitle: '${creating ? 'Layanan baru' : 'Edit layanan'} · ${business ?? 'Laurum'}',
      appBarVariant: AppBarSubVariant.detail,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xlarge,
        AppSpacing.medium,
        AppSpacing.xlarge,
        AppSpacing.xlarge,
      ),
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya/layanan'),
      footer: state == null
          ? const SizedBox.shrink()
          : ServiceFormFooterSection(
              isEdit: state.isEdit,
              busy: state.busy,
              onSave: save,
              onCancel: () => context.pop(),
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
        data: (value) {
          final actions = ref.read(serviceEditProvider(serviceId).notifier);
          return ServiceFormSection(
            state: value,
            onName: actions.setName,
            onKind: actions.setKind,
            onPrice: actions.setPrice,
            onDuration: actions.setDuration,
            onActive: (value) => actions.setActive(value: value),
          );
        },
      ),
    );
  }
}
