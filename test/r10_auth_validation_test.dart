import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/auth/state/auth_validation.dart';

void main() {
  test('email, name, password and confirmation validation table', () {
    for (final value in ['', 'not-an-email', 'a@b', 'a b@example.com']) {
      expect(authEmailError(value), isNotNull);
    }
    expect(authEmailError(' RATNA@example.com '), isNull);
    expect(authNameError('  '), isNotNull);
    expect(authNameError('Bu Ratna'), isNull);
    expect(authPasswordError('1234567'), isNotNull);
    expect(authPasswordError('12345678'), isNull);
    expect(authConfirmationError('same', 'same'), isNull);
    expect(authConfirmationError('one', 'two'), isNotNull);
  });
  test('phone is optional, Indonesian mobile prefixes only, no OTP', () {
    for (final value in ['', '081234567890', '+6281234567890', '0812-3456-7890']) {
      expect(authPhoneError(value), isNull, reason: value);
    }
    for (final value in ['123', '+12025550123', '0812abc456', '02112345678']) {
      expect(authPhoneError(value), isNotNull, reason: value);
    }
  });
  test('reset cooldown works with business clock or elapsed timer ticks', () {
    final sent = DateTime(2026, 10, 16);
    expect(resetWaitSeconds(sent, sent), 60);
    expect(resetWaitSeconds(sent, sent.add(const Duration(seconds: 59))), 1);
    expect(resetWaitSeconds(sent, sent.add(const Duration(seconds: 60))), 0);
    expect(resetWaitSeconds(sent, sent, ticks: 60), 0);
  });
}
