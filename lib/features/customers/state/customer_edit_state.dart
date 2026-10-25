import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/features/transactions/pages/add_customer_form.dart';

class CustomerEditState {
  const CustomerEditState({
    this.customer,
    this.form = const AddCustomerState(),
    this.busy = false,
    this.error,
  });
  final Customer? customer;
  final AddCustomerState form;
  final bool busy;
  final String? error;
  CustomerEditState copyWith({AddCustomerState? form, bool? busy, String? error}) =>
      CustomerEditState(
        customer: customer,
        form: form ?? this.form,
        busy: busy ?? this.busy,
        error: error,
      );
}

Customer revisedCustomer(Customer current, DateTime at, {AddCustomerState? form, bool? active}) =>
    Customer(
      id: current.id,
      ownerId: current.ownerId,
      createdAt: current.createdAt,
      updatedAt: at,
      name: form?.name.trim() ?? current.name,
      phone: form == null ? current.phone : normalizePhone(form.phone),
      address: form?.address.trim() ?? current.address,
      notes: form?.notes.trim() ?? current.notes,
      isActive: active ?? current.isActive,
      deletedAt: current.deletedAt,
    );
