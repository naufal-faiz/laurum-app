import 'package:laurum/core/domain/savings_entry.dart';

// Sync metadata may advance after a push; the financial entry remains immutable.
bool sameSavingsContent(SavingsEntry a, SavingsEntry b) =>
    a.id == b.id &&
    a.ownerId == b.ownerId &&
    a.createdAt == b.createdAt &&
    a.customerId == b.customerId &&
    a.kind == b.kind &&
    a.amount == b.amount &&
    a.method == b.method &&
    a.orderId == b.orderId &&
    a.note == b.note;
