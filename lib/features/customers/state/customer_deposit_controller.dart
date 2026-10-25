import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/customers/pages/customer_deposit_state.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

final customerDepositProvider =
    NotifierProvider.family<CustomerDepositController, CustomerDepositState, String>(
      CustomerDepositController.new,
    );

class CustomerDepositController extends Notifier<CustomerDepositState> {
  CustomerDepositController(this.customerId);
  final String customerId;

  @override
  CustomerDepositState build() => const CustomerDepositState();

  void key(AppNumpadKeyValue key) {
    final value = state.text;
    final String text;
    if (key == AppNumpadKeyValue.backspace) {
      text = value.isEmpty ? '' : value.substring(0, value.length - 1);
    } else if (key == AppNumpadKeyValue.decimal) {
      return;
    } else if (key == AppNumpadKeyValue.tripleZero) {
      text = value.isEmpty || value == '0' || value.length > 6 ? value : '${value}000';
    } else {
      text = value.length >= 9
          ? value
          : value == '0'
          ? key.label
          : '$value${key.label}';
    }
    state = state.withInput(text: text);
  }

  void add(int delta) => state = state.withInput(text: '${state.amount + delta}');

  void setMethod(PayMethod method) => state = state.withInput(method: method);

  void setNote(String note) => state = state.withInput(note: note);

  Future<bool> save() async {
    if (state.busy) return false;
    final amount = state.amount;
    if (amount <= 0) {
      state = state.withStatus(nominalError: 'Nominal harus lebih dari Rp0.');
      return false;
    }
    final note = state.note.trim();
    final now = ref.read(businessClockProvider)();
    state = state.withStatus(busy: true);
    try {
      await ref
          .read(savingsRepositoryProvider)
          .addEntry(
            SavingsEntry(
              id: 'sav-${now.microsecondsSinceEpoch}',
              ownerId: ref.read(authServiceProvider).currentUserId ?? 'owner',
              createdAt: now,
              customerId: customerId,
              kind: SavingsKind.setor,
              amount: amount,
              method: state.method,
              note: note.isEmpty ? 'Setoran tabungan' : note,
            ),
          );
      state = state.withStatus(busy: false);
      return true;
    } catch (_) {
      state = state.withStatus(busy: false, error: 'Setoran gagal disimpan. Coba lagi.');
      return false;
    }
  }
}
