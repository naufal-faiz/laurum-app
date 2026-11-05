import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/password_reset.dart';
import 'package:laurum/features/business/state/business_info_controller.dart';
import 'package:laurum/features/customers/state/customer_deposit_controller.dart';
import 'package:laurum/features/customers/state/customer_import_controller.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/features/proposals/state/ai_settings.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/transactions/state/checkout_notice.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

void resetAccountDrafts(Ref ref) {
  ref.invalidate(transactionDraftProvider);
  ref.invalidate(expenseFormProvider);
  ref.invalidate(proposalDraftProvider);
  ref.invalidate(businessInfoProvider);
  ref.invalidate(passwordResetProvider);
  ref.invalidate(authFormProvider);
  ref.invalidate(customerImportSelectionProvider);
  ref.invalidate(customerDepositProvider);
  ref.invalidate(aiSettingsProvider);
  ref.invalidate(checkoutControllerProvider);
  ref.invalidate(checkoutNoticeProvider);
}
