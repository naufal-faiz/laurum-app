import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

class AddCustomerState {
  const AddCustomerState({
    this.name = '',
    this.phone = '',
    this.address = '',
    this.notes = '',
    this.nameError,
    this.phoneError,
    this.duplicate,
  });
  final String name, phone, address, notes;
  final String? nameError, phoneError;
  final Customer? duplicate;
  AddCustomerState copyWith({
    String? name,
    String? phone,
    String? address,
    String? notes,
    String? nameError,
    String? phoneError,
    Customer? duplicate,
  }) => AddCustomerState(
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    notes: notes ?? this.notes,
    nameError: nameError,
    phoneError: phoneError,
    duplicate: duplicate,
  );
}

class AddCustomerForm extends Notifier<AddCustomerState> {
  @override
  AddCustomerState build() => const AddCustomerState();

  void setName(String value) => state = state.copyWith(name: value);
  void setPhone(String value) => state = state.copyWith(phone: value);
  void setAddress(String value) => state = state.copyWith(address: value);
  void setNotes(String value) => state = state.copyWith(notes: value);
  void fillContact(String name, String phone) => state = state.copyWith(name: name, phone: phone);
  void reset() => state = const AddCustomerState();

  Future<Customer?> save() async {
    final name = state.name.trim();
    final phone = normalizePhone(state.phone);
    if (name.isEmpty || phone.length < 10) {
      state = state.copyWith(
        nameError: name.isEmpty ? 'Nama wajib diisi.' : null,
        phoneError: phone.length < 10 ? 'Nomor WhatsApp tidak valid.' : null,
      );
      return null;
    }
    final repository = ref.read(customerRepositoryProvider);
    final customers = await repository.getCustomers(includeInactive: true);
    final existing = customers
        .where((c) => c.deletedAt == null && normalizePhone(c.phone) == phone)
        .firstOrNull;
    if (existing != null) {
      state = state.copyWith(
        phoneError: 'Nomor ini sudah terdaftar atas nama ${existing.name}.',
        duplicate: existing,
      );
      return null;
    }
    final now = ref.read(businessClockProvider)();
    final customer = Customer(
      id: 'cust-new-${customers.length + 1}',
      ownerId: ref.read(authServiceProvider).currentUserId ?? 'owner',
      createdAt: now,
      name: name,
      phone: phone,
      address: state.address.trim(),
      notes: state.notes.trim(),
    );
    try {
      await repository.saveCustomer(customer);
      state = const AddCustomerState();
      return customer;
    } on StateError {
      state = state.copyWith(phoneError: 'Nomor ini sudah terdaftar.');
      return null;
    }
  }
}

String normalizePhone(String value) {
  var digits = value.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('62')) digits = '0${digits.substring(2)}';
  if (digits.startsWith('8')) digits = '0$digits';
  return digits;
}

final addCustomerFormProvider = NotifierProvider<AddCustomerForm, AddCustomerState>(
  AddCustomerForm.new,
);
