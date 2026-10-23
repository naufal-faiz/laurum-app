import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/receipt_settings.dart';

import 'domain_samples.dart';

void main() {
  test('ReceiptSettings equality includes its fields', () {
    ReceiptSettings make(String value) =>
        ReceiptSettings(id: 'id', ownerId: 'owner', createdAt: day, showNote: value == 'same');
    expect(make('same'), make('same'));
    expect(make('same').hashCode, make('same').hashCode);
    expect(make('same'), isNot(make('different')));
  });
  test('OrderEvent equality includes its fields', () {
    OrderEvent make(String value) => OrderEvent(
      id: 'id',
      ownerId: 'owner',
      createdAt: day,
      orderId: 'o',
      occurredAt: day,
      kind: value,
    );
    expect(make('same'), make('same'));
    expect(make('same').hashCode, make('same').hashCode);
    expect(make('same'), isNot(make('different')));
  });
}
