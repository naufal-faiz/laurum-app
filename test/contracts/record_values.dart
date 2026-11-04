import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/savings_entry.dart';

// Compare every business field; updatedAt/syncState belong to storage/sync.
Object? customerValue(Customer? c) => c == null
    ? null
    : (
        c.id,
        c.ownerId,
        c.createdAt,
        c.name,
        c.phone,
        c.address,
        c.notes,
        c.isActive,
        c.deletedAt,
      );
Object savingsValue(SavingsEntry e) => (
  e.id,
  e.ownerId,
  e.createdAt,
  e.customerId,
  e.kind,
  e.amount,
  e.method,
  e.orderId,
  e.note,
);
