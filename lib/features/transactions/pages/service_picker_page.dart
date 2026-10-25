import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class ServicePickerPage extends ConsumerWidget {
  const ServicePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(serviceSearchProvider).toLowerCase();
    final catalog = ref.watch(serviceCatalogProvider);
    return SubScaffold(
      title: 'Pilih layanan',
      backLabel: 'Kembali',
      onBack: () => Navigator.of(context).pop(),
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
        data: (services) {
          final active = services.where((s) => s.isActive).toList();
          final matches = active.where((s) => s.name.toLowerCase().contains(query)).toList();
          final sections = <({String title, List<ServiceItem> items})>[
            if (query.isEmpty) (title: 'Sering dipakai', items: active.take(3).toList()),
            if (query.isEmpty)
              (title: 'Kiloan', items: matches.where((s) => s.kind == ServiceKind.kiloan).toList()),
            if (query.isEmpty)
              (title: 'Satuan', items: matches.where((s) => s.kind == ServiceKind.satuan).toList()),
            if (query.isNotEmpty) (title: 'Hasil pencarian', items: matches),
          ];
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              AppSearchField(
                label: 'Cari layanan',
                clearLabel: 'Hapus pencarian',
                hint: 'Cari nama layanan (misal: selimut, karpet)',
                value: ref.watch(serviceSearchProvider),
                onChanged: ref.read(serviceSearchProvider.notifier).set,
              ),
              const SizedBox(height: AppSpacing.cardGap),
              if (matches.isEmpty && query.isNotEmpty)
                const EmptyState(
                  title: 'Layanan tidak ditemukan',
                  icon: AppIcons.service,
                  description: 'Coba kata kunci lain.',
                )
              else
                for (final section in sections) ...[
                  SectionHeader(title: section.title),
                  Column(
                    spacing: AppSpacing.cardGap,
                    children: [
                      for (final service in section.items)
                        MenuRow(
                          label: service.name,
                          subtitle: _subtitle(service),
                          icon: AppIcons.service,
                          onTap: () => _add(context, ref, service),
                        ),
                    ],
                  ),
                ],
            ],
          );
        },
      ),
    );
  }

  void _add(BuildContext context, WidgetRef ref, ServiceItem service) {
    ref.read(transactionDraftProvider.notifier).add(service);
    Navigator.of(context).pop();
  }
}

String _subtitle(ServiceItem service) =>
    '${service.kind == ServiceKind.kiloan ? 'Kiloan' : 'Satuan'} · '
    '${Formatters.rupiah(service.price)}/${service.kind == ServiceKind.kiloan ? 'kg' : 'pcs'} · '
    '${service.durationDays} hari';
