import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_import_controller.dart';
import 'package:laurum/features/customers/pages/customer_import_data.dart';
import 'package:laurum/features/customers/pages/customer_import_list_page.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class CustomerImportPage extends ConsumerWidget {
  const CustomerImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactImportProvider);
    final selection = ref.watch(customerImportSelectionProvider);
    final data = contacts.value;
    final chosen = data == null
        ? 0
        : data.rows.where((row) => !row.exists && selection.selected.contains(row.key)).length;
    return FormScaffold(
      title: 'Impor kontak HP',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/pelanggan'),
      footer: AppButton(
        'Simpan $chosen pelanggan',
        onPressed: chosen == 0 || data == null
            ? null
            : () async {
                await ref.read(customerImportSelectionProvider.notifier).save(data);
                if (context.mounted) {
                  context.canPop() ? context.pop() : context.go('/pelanggan');
                }
              },
      ),
      body: contacts.when(
        loading: () => const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [AppSkeleton(height: 120), AppSkeleton(height: 320)],
        ),
        error: (error, _) => error is ContactPermissionDenied
            ? EmptyState(
                title: 'Izin kontak belum diberikan',
                icon: AppIcons.lock,
                description: 'Izinkan akses kontak agar nomor bisa diimpor.',
                actionLabel: 'Buka pengaturan',
                onAction: () => ref.read(externalLauncherProvider).launchUrl('app-settings:'),
              )
            : EmptyState(
                title: 'Kontak tidak tersedia',
                icon: AppIcons.alert,
                description: 'Periksa izin kontak lalu coba lagi.',
                actionLabel: 'Coba lagi',
                onAction: () => ref.invalidate(contactImportProvider),
              ),
        data: (value) => CustomerImportListPage(data: value),
      ),
    );
  }
}
