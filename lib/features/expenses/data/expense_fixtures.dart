import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/features/expenses/data/prior_expense_fixtures.dart';
import 'package:laurum/features/expenses/data/week_expense_fixtures.dart';

export 'package:laurum/features/expenses/data/expense_category_fixtures.dart';

final expenseFixtures = <Expense>[
  ...weekExpenseFixtures,
  ...priorExpenseFixtures,
];
