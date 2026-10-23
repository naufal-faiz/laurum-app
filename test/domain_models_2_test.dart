import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/expense.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/domain/proposal.dart';

import 'domain_samples.dart';

void main() {
  test('ExpenseCategory equality includes its fields', () {
    ExpenseCategory make(String value) =>
        ExpenseCategory(id: 'id', ownerId: 'owner', createdAt: day, name: value);
    expect(make('same'), make('same'));
    expect(make('same').hashCode, make('same').hashCode);
    expect(make('same'), isNot(make('different')));
  });
  test('Expense equality includes its fields', () {
    Expense make(String value) => Expense(
      id: 'id',
      ownerId: 'owner',
      createdAt: day,
      categoryId: value,
      amount: 100,
      spentAt: day,
    );
    expect(make('same'), make('same'));
    expect(make('same').hashCode, make('same').hashCode);
    expect(make('same'), isNot(make('different')));
  });
  test('Proposal equality includes its fields', () {
    Proposal make(String value) => Proposal(
      id: 'id',
      ownerId: 'owner',
      createdAt: day,
      status: ProposalStatus.menunggu,
      sourceText: value,
    );
    expect(make('same'), make('same'));
    expect(make('same').hashCode, make('same').hashCode);
    expect(make('same'), isNot(make('different')));
  });
}
