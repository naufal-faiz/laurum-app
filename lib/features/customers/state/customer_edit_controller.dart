import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_edit_state.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/add_customer_form.dart';

class CustomerEditController extends Notifier<CustomerEditState> {
  @override
  CustomerEditState build() => const CustomerEditState();
  void start(Customer customer) => state = CustomerEditState(
    customer: customer,
    form: AddCustomerState(
      name: customer.name,
      phone: customer.phone,
      address: customer.address,
      notes: customer.notes,
    ),
  );
  void setName(String value) => state = state.copyWith(form: state.form.copyWith(name: value));
  void setPhone(String value) => state = state.copyWith(form: state.form.copyWith(phone: value));
  void setAddress(String value) =>
      state = state.copyWith(form: state.form.copyWith(address: value));
  void setNotes(String value) => state = state.copyWith(form: state.form.copyWith(notes: value));

  Future<bool> save() => _persist(deactivate: false);
  Future<bool> deactivate() => _persist(deactivate: true);

  Future<bool> _persist({required bool deactivate}) async {
    if (state.busy || state.customer == null) return false;
    final form = state.form;
    final id = state.customer!.id;
    final phone = normalizePhone(form.phone);
    if (!deactivate && (form.name.trim().isEmpty || !RegExp(r'^08\d{8,11}$').hasMatch(phone))) {
      state = state.copyWith(
        form: form.copyWith(
          nameError: form.name.trim().isEmpty ? 'Nama wajib diisi.' : null,
          phoneError: !RegExp(r'^08\d{8,11}$').hasMatch(phone)
              ? 'Nomor WhatsApp tidak valid.'
              : null,
        ),
      );
      return false;
    }
    final repository = ref.read(customerRepositoryProvider);
    final at = ref.read(businessClockProvider)();
    state = state.copyWith(busy: true);
    try {
      final current = await repository.getCustomerById(id);
      if (current == null || !current.isActive) {
        state = state.copyWith(
          busy: false,
          error: 'Pelanggan sudah tidak aktif atau tidak tersedia.',
        );
        return false;
      }
      if (!deactivate) {
        final duplicate = (await repository.getCustomers())
            .where((c) => c.id != id && normalizePhone(c.phone) == phone)
            .firstOrNull;
        if (duplicate != null) {
          state = state.copyWith(
            busy: false,
            form: form.copyWith(
              phoneError: 'Nomor ini sudah terdaftar atas nama ${duplicate.name}.',
            ),
          );
          return false;
        }
      }
      await repository.saveCustomer(
        revisedCustomer(
          current,
          at,
          form: deactivate ? null : form,
          active: deactivate ? false : null,
        ),
      );
      state = state.copyWith(busy: false);
      return true;
    } catch (_) {
      state = state.copyWith(busy: false, error: 'Perubahan gagal disimpan. Coba lagi.');
      return false;
    }
  }
}

final customerEditProvider = NotifierProvider<CustomerEditController, CustomerEditState>(
  CustomerEditController.new,
);
