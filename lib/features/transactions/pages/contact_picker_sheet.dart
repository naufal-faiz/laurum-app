import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/transactions/state/add_customer_form.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

final contactsProvider = FutureProvider<List<ContactItem>>(
  (ref) => ref.watch(contactSourceProvider).getContacts(),
);

class ContactPickerSheet extends ConsumerWidget {
  const ContactPickerSheet({super.key});

  static Future<void> show(BuildContext context, WidgetRef ref) => AppBottomSheet.show<void>(
    context: context,
    title: 'Ambil dari kontak HP',
    subtitle: 'Pilih kontak untuk mengisi nama dan nomor',
    child: const ContactPickerSheet(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);
    return SizedBox(
      height: 420,
      child: contacts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const EmptyState(
          title: 'Kontak tidak tersedia',
          icon: AppIcons.alert,
          description: 'Izinkan akses kontak lalu coba lagi.',
        ),
        data: (items) => items.isEmpty
            ? const EmptyState(title: 'Belum ada kontak', icon: AppIcons.customers)
            : ListView(
                children: [
                  for (final contact in items)
                    MenuRow(
                      label: contact.name,
                      subtitle: contact.phone,
                      icon: AppIcons.person,
                      onTap: () {
                        ref
                            .read(addCustomerFormProvider.notifier)
                            .fillContact(contact.name, contact.phone);
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
      ),
    );
  }
}
