import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef DiscountInputState = ({String text, String? error});

class DiscountInput extends Notifier<DiscountInputState> {
  @override
  DiscountInputState build() => (text: '', error: null);
  void start(int current) => state = (text: current <= 0 ? '' : '$current', error: null);
  void set(String value) {
    final digits = value.replaceAll(RegExp('[^0-9]'), '').replaceFirst(RegExp('^0+'), '');
    state = (text: digits, error: null);
  }

  void error(String message) => state = (text: state.text, error: message);
}

final discountInputProvider = NotifierProvider<DiscountInput, DiscountInputState>(
  DiscountInput.new,
);
