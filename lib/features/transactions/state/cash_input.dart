import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

final cashInputProvider = NotifierProvider<CashInput, String>(CashInput.new);

class CashInput extends Notifier<String> {
  @override
  String build() => '';
  void start(int value) => state = value <= 0 ? '' : '$value';
  void key(AppNumpadKeyValue key) {
    if (key == AppNumpadKeyValue.backspace) {
      state = state.isEmpty ? '' : state.substring(0, state.length - 1);
    } else if (key == AppNumpadKeyValue.tripleZero) {
      state = state.isEmpty || state == '0' ? '' : '${state}000';
    } else if (state != '0') {
      state = '$state${key.label}';
    }
  }

  void set(int value) => state = '$value';
}
