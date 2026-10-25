import 'package:flutter/material.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/state/service_directory_data.dart';
import 'package:laurum/features/services/widgets/service_directory_list_section.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class ServiceDirectoryContentSection extends StatelessWidget {
  const ServiceDirectoryContentSection({
    required this.services,
    required this.query,
    required this.onQuery,
    required this.onTap,
    required this.onToggle,
    super.key,
  });

  final List<ServiceItem> services;
  final String query;
  final ValueChanged<String> onQuery;
  final ValueChanged<ServiceItem> onTap;
  final void Function(ServiceItem service, {required bool active}) onToggle;

  @override
  Widget build(BuildContext context) {
    final items = visibleServices(services, query);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              AppSearchField(
                label: 'Cari layanan',
                clearLabel: 'Hapus pencarian',
                hint: 'Cari layanan laundry...',
                value: query,
                onChanged: onQuery,
              ),
              SectionHeader(title: serviceSummary(services)),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: EmptyState(
                    title: 'Layanan tidak ditemukan',
                    icon: AppIcons.service,
                    description: 'Coba kata kunci lain.',
                  ),
                )
              : ServiceDirectoryListSection(
                  services: items,
                  onTap: onTap,
                  onToggle: onToggle,
                ),
        ),
      ],
    );
  }
}
