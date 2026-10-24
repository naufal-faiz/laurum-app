import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_import_controller.dart';
import 'package:laurum/features/customers/pages/customer_import_data.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

class CustomerImportListPage extends ConsumerWidget {
  const CustomerImportListPage({required this.data, super.key});
  final ContactImportData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(customerImportSelectionProvider);
    final actions = ref.read(customerImportSelectionProvider.notifier);
    final visible = filterContacts(data.rows, selection.query);
    final visibleNew = visible.where((row) => !row.exists).toList();
    final allSelected =
        visibleNew.isNotEmpty && visibleNew.every((row) => selection.selected.contains(row.key));
    final chosen = data.rows
        .where((row) => !row.exists && selection.selected.contains(row.key))
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        const AppCard(
          child: AppText(
            'Aplikasi membaca kontak di HP Anda untuk mempercepat pencatatan pelanggan '
            'tanpa perlu mengetik ulang satu per satu.',
          ),
        ),
        AppSearchField(
          label: 'Nama pelanggan',
          clearLabel: 'Hapus pencarian',
          hint: 'Cari nama atau nomor kontak...',
          value: selection.query,
          onChanged: actions.setQuery,
        ),
        AppButton(
          allSelected ? 'Batalkan pilihan' : 'Pilih semua (${visibleNew.length} kontak)',
          variant: AppButtonVariant.actionOutline,
          onPressed: visibleNew.isEmpty
              ? null
              : () {
                  final keys = {...selection.selected};
                  final fresh = visibleNew.map((row) => row.key);
                  allSelected ? keys.removeAll(fresh) : keys.addAll(fresh);
                  actions.selectAll(keys);
                },
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              const AppText('Siap impor', variant: AppTextVariant.bodyStrong),
              AppText(
                '${data.existing} nomor sudah terdaftar di sistem dan akan otomatis dilewati',
                variant: AppTextVariant.caption,
              ),
              AppText('$chosen kontak baru dipilih (${data.existing} dilewati)'),
              AppText('Total ${data.rows.length} kontak', variant: AppTextVariant.caption),
            ],
          ),
        ),
        if (visible.isEmpty)
          EmptyState(
            title: data.rows.isEmpty ? 'Belum ada kontak' : 'Kontak tidak ditemukan',
            icon: AppIcons.search,
            description: data.rows.isEmpty ? null : 'Ubah kata kunci atau kosongkan pencarian.',
          )
        else
          for (final row in visible)
            ToggleRow(
              label: row.contact.name,
              description: row.exists
                  ? '${Formatters.telepon(row.contact.phone)} • Sudah ada (dilewati)'
                  : Formatters.telepon(row.contact.phone),
              icon: AppIcons.person,
              value: selection.selected.contains(row.key),
              onChanged: row.exists ? null : (_) => actions.toggle(row.key),
            ),
      ],
    );
  }
}
