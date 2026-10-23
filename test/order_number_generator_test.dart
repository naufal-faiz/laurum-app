import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/order_number_generator.dart';

void main() {
  group('OrderNumberGenerator', () {
    const generator = OrderNumberGenerator();

    test('formats sequence to 4 digits', () {
      expect(generator.format(1), 'A-0001');
      expect(generator.format(142), 'A-0142');
      expect(generator.format(9999), 'A-9999');
    });

    test('rejects sequence outside range 1-9999', () {
      expect(() => generator.format(0), throwsArgumentError);
      expect(() => generator.format(10000), throwsArgumentError);
    });

    test('parses sequence correctly', () {
      expect(generator.parseSequence('A-0142'), 142);
      expect(generator.parseSequence('B-0001'), null);
      expect(generator.parseSequence('invalid'), null);
    });

    test('generates next order number from empty list', () {
      expect(generator.nextOrderNo([]), 'A-0001');
    });

    test('generates A-0143 when latest order is A-0142', () {
      final existing = ['A-0128', 'A-0136', 'A-0140', 'A-0141', 'A-0142'];
      expect(generator.nextOrderNo(existing), 'A-0143');
    });
  });
}
