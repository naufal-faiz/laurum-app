import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/features/transactions/widgets/service_picker_list_section.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class ServicePickerPage extends ConsumerWidget {
  const ServicePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(serviceSearchProvider);
    final catalog = ref.watch(serviceCatalogProvider);
    return SubScaffold(
      title: 'Pilih layanan',
      backLabel: 'Kembali',
      onBack: () => Navigator.of(context).pop(),
      fabLabel: 'Layanan baru',
      onFab: () async {
        await context.push<void>('/lainnya/layanan/baru');
        if (context.mounted) ref.invalidate(serviceCatalogProvider);
      },
      body: catalog.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [for (var i = 0; i < 4; i++) const AppSkeleton()],
        ),
        error: (_, _) => Center(
          child: EmptyState(
            title: 'Gagal memuat layanan',
            icon: AppIcons.alert,
            actionLabel: 'Coba lagi',
            onAction: () => ref.invalidate(serviceCatalogProvider),
          ),
        ),
        data: (services) => ServicePickerListSection(
          services: services,
          query: query,
          onSearch: ref.read(serviceSearchProvider.notifier).set,
          onSelect: (service) {
            ref.read(transactionDraftProvider.notifier).add(service);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
