import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class ServicePickerListSection extends StatelessWidget {
  const ServicePickerListSection({
    required this.services,
    required this.query,
    required this.onSearch,
    required this.onSelect,
    super.key,
  });
  final List<ServiceItem> services;
  final String query;
  final ValueChanged<String> onSearch;
  final ValueChanged<ServiceItem> onSelect;

  @override
  Widget build(BuildContext context) {
    final keyword = query.toLowerCase();
    final active = services.where((s) => s.isActive).toList();
    final matches = active.where((s) => s.name.toLowerCase().contains(keyword)).toList();
    final sections = <({String title, List<ServiceItem> items})>[
      if (keyword.isEmpty) (title: 'Sering dipakai', items: active.take(3).toList()),
      if (keyword.isEmpty)
        (title: 'Kiloan', items: matches.where((s) => s.kind == ServiceKind.kiloan).toList()),
      if (keyword.isEmpty)
        (title: 'Satuan', items: matches.where((s) => s.kind == ServiceKind.satuan).toList()),
      if (keyword.isNotEmpty) (title: 'Hasil pencarian', items: matches),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.screenPadding,
        AppSpacing.screenPadding,
        AppSpacing.screenPadding + AppSpacing.touchTarget * 2,
      ),
      children: [
        AppSearchField(
          label: 'Cari layanan',
          clearLabel: 'Hapus pencarian',
          hint: 'Cari nama layanan (misal: selimut, karpet)',
          value: query,
          onChanged: onSearch,
        ),
        const SizedBox(height: AppSpacing.cardGap),
        if (matches.isEmpty && keyword.isNotEmpty)
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
                    onTap: () => onSelect(service),
                  ),
              ],
            ),
          ],
      ],
    );
  }
}

String _subtitle(ServiceItem service) =>
    '${service.kind == ServiceKind.kiloan ? 'Kiloan' : 'Satuan'} · '
    '${Formatters.rupiah(service.price)}/${service.kind == ServiceKind.kiloan ? 'kg' : 'pcs'} · '
    '${service.durationDays} hari';
