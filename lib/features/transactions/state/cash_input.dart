import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

final cashInputProvider = NotifierProvider<CashInput, String>(CashInput.new);

class CashInput extends Notifier<String> {
  bool _fresh = false;
  @override
  String build() => '';
  void start(int value) {
    state = value <= 0 ? '' : '$value';
    _fresh = true;
  }

  void key(AppNumpadKeyValue key) {
    if (key == AppNumpadKeyValue.decimal) return;
    if (_fresh) {
      state = '';
      _fresh = false;
    }
    if (key == AppNumpadKeyValue.backspace) {
      state = state.isEmpty ? '' : state.substring(0, state.length - 1);
    } else if (key == AppNumpadKeyValue.tripleZero) {
      state = state.isEmpty || state == '0' ? '' : '${state}000';
    } else if (key == AppNumpadKeyValue.decimal) {
      return;
    } else if (state.length < 9) {
      state = state == '0' ? key.label : '$state${key.label}';
    }
    if (state == '0') state = '';
  }

  void set(int value) {
    state = value <= 0 ? '' : '$value';
    _fresh = false;
  }
}
