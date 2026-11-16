import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/outstanding_data.dart';
import 'package:laurum/features/reports/state/report_orders_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/services/state/service_directory_providers.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

typedef DataRefreshQuery = Refreshable<Future<Object?>>;

// Read-only queries only. Never invalidate an account store or an editable draft.
// Dependencies precede their derived queries so reads do not cancel each other.
final dataRefreshQueriesProvider = Provider<List<DataRefreshQuery>>(
  (ref) => [
    businessProfileProvider.future,
    antreanDataProvider.future,
    customerSummariesProvider.future,
    customerDirectoryProvider.future,
    weeklyReportViewProvider.future,
    reportViewProvider.future,
    reportOrdersProvider.future,
    expenseDirectoryProvider.future,
    serviceDirectoryProvider.future,
    outstandingListProvider.future,
  ],
);
