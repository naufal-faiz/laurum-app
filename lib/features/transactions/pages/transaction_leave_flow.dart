import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

Future<void> leaveTransaction(BuildContext context, WidgetRef ref) async {
  final draft = ref.read(transactionDraftProvider);
  if (!draft.isEmpty) {
    final leave = await ConfirmModal.show(
      context: context,
      title: 'Keluar tanpa menyimpan?',
      message: 'Draf nota berisi ${draft.itemCount} layanan akan hilang.',
      confirmLabel: 'Keluar tanpa simpan',
      destructive: true,
    );
    if (leave != true || !context.mounted) return;
  }
  ref.read(transactionDraftProvider.notifier).clear();
  if (!context.mounted) return;
  context.canPop() ? context.pop() : context.go('/antrean');
}
