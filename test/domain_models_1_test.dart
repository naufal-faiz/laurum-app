import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';

import 'domain_samples.dart';

void main() {
  test('BusinessProfile equality includes its fields', () {
    BusinessProfile make(String value) =>
        BusinessProfile(id: 'id', ownerId: 'owner', createdAt: day, name: value);
    expect(make('same'), make('same'));
    expect(make('same').hashCode, make('same').hashCode);
    expect(make('same'), isNot(make('different')));
  });
  test('Customer equality includes its fields', () {
    Customer make(String value) =>
        Customer(id: 'id', ownerId: 'owner', createdAt: day, name: value);
    expect(make('same'), make('same'));
    expect(make('same').hashCode, make('same').hashCode);
    expect(make('same'), isNot(make('different')));
  });
  test('ServiceItem equality includes its fields', () {
    ServiceItem make(String value) => ServiceItem(
      id: 'id',
      ownerId: 'owner',
      createdAt: day,
      name: value,
      kind: ServiceKind.kiloan,
      price: 100,
      durationDays: 1,
    );
    expect(make('same'), make('same'));
    expect(make('same').hashCode, make('same').hashCode);
    expect(make('same'), isNot(make('different')));
  });
}
