import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

Future<void> showExpenseDatePicker(BuildContext context, WidgetRef ref) async {
  final draft = ref.read(expenseFormProvider);
  final now = ref.read(businessClockProvider)();
  final date = await showDatePicker(
    context: context,
    initialDate: draft.date,
    firstDate: DateTime(2026),
    lastDate: now,
    locale: const Locale('id', 'ID'),
  );
  if (date == null) return;
  ref
      .read(expenseFormProvider.notifier)
      .date(DateTime(date.year, date.month, date.day, draft.date.hour, draft.date.minute));
}
