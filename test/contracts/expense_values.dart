import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';

Object expenseValue(Expense e) => (
  e.id,
  e.ownerId,
  e.createdAt,
  e.categoryId,
  e.amount,
  e.spentAt,
  e.vendor,
  e.note,
  e.photoPath,
  e.deletedAt,
);
Object categoryValue(ExpenseCategory c) =>
    (c.id, c.ownerId, c.createdAt, c.name, c.isDefault, c.deletedAt);
