import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/transactions/pages/add_customer_form.dart';

class ContactImportRow {
  const ContactImportRow(this.contact, {required this.exists});
  final ContactItem contact;
  final bool exists;
  String get key => normalizePhone(contact.phone);
}

class ContactImportData {
  const ContactImportData(this.rows);
  final List<ContactImportRow> rows;
  int get existing => rows.where((row) => row.exists).length;
  int get fresh => rows.where((row) => !row.exists).length;
  List<ContactImportRow> get visibleNew => rows.where((row) => !row.exists).toList();
}

List<ContactImportRow> filterContacts(List<ContactImportRow> rows, String search) {
  final query = search.trim().toLowerCase();
  final phone = normalizePhone(query);
  return rows
      .where(
        (row) =>
            query.isEmpty ||
            row.contact.name.toLowerCase().contains(query) ||
            (phone.isNotEmpty && row.key.contains(phone)),
      )
      .toList();
}

final contactImportProvider = FutureProvider<ContactImportData>(
  (ref) async {
    final contacts = await ref.watch(contactSourceProvider).getContacts();
    final customers = await ref
        .watch(customerRepositoryProvider)
        .getCustomers(includeInactive: true);
    final phones = {
      for (final customer in customers)
        if (normalizePhone(customer.phone).isNotEmpty) normalizePhone(customer.phone),
    };
    final rows = [
      for (final contact in contacts)
        ContactImportRow(contact, exists: phones.contains(normalizePhone(contact.phone))),
    ]..sort((a, b) => a.contact.name.toLowerCase().compareTo(b.contact.name.toLowerCase()));
    return ContactImportData(rows);
  },
  // Izin ditolak harus tampil sebagai state akhir, bukan dicoba ulang terus.
  retry: (retryCount, error) => null,
);
