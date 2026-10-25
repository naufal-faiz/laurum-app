import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef DiscountInputState = ({String text, String? error});

class DiscountInput extends Notifier<DiscountInputState> {
  @override
  DiscountInputState build() => (text: '', error: null);
  void start(int current) => state = (text: '$current', error: null);
  void set(String value) => state = (text: value, error: null);
  void error(String message) => state = (text: state.text, error: message);
}

final discountInputProvider = NotifierProvider<DiscountInput, DiscountInputState>(
  DiscountInput.new,
);
