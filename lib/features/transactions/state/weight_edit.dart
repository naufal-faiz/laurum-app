import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

typedef WeightEditState = ({String serviceId, String text, int milli, bool fresh});

class WeightEdit extends Notifier<WeightEditState> {
  @override
  WeightEditState build() => (serviceId: '', text: '', milli: 0, fresh: false);

  void start(DraftLine line) {
    final text = line.service.kind == ServiceKind.kiloan
        ? _plainWeight(line.qtyMilli)
        : '${line.qtyMilli ~/ 1000}';
    state = (
      serviceId: line.service.id,
      text: text,
      milli: line.qtyMilli,
      fresh: true,
    );
  }

  void key(AppNumpadKeyValue key) {
    final line = ref.read(transactionDraftProvider).lineFor(state.serviceId);
    if (line == null) return;
    final kilo = line.service.kind == ServiceKind.kiloan;
    final value = state.text;
    final String text;
    if (key == AppNumpadKeyValue.decimal) {
      if (!kilo) return;
      text = state.fresh || value.isEmpty ? '0,' : (value.contains(',') ? value : '$value,');
    } else if (key == AppNumpadKeyValue.backspace) {
      text = _backspace(state.fresh ? '' : value);
    } else if (key == AppNumpadKeyValue.tripleZero) {
      text = state.fresh || value.isEmpty || value == '0' ? '' : '${value}000';
    } else {
      text = _type(state.fresh ? '' : value, key.label);
    }
    state = (
      serviceId: state.serviceId,
      text: text,
      milli: _milliFor(text, line),
      fresh: false,
    );
  }

  void add(int deltaMilli) {
    final next = state.milli + deltaMilli;
    state = (
      serviceId: state.serviceId,
      text: _plainWeight(next),
      milli: next,
      fresh: false,
    );
  }
}

String _type(String value, String digit) {
  if (value.isEmpty || value == '0') return digit == '0' ? '' : digit;
  return value.length < 6 ? '$value$digit' : value;
}

String _backspace(String value) =>
    value.isEmpty || value == '0' || value == '0,' ? '' : value.substring(0, value.length - 1);

int _milliFor(String text, DraftLine line) {
  if (line.service.kind == ServiceKind.kiloan) {
    return ((double.tryParse(text.replaceAll(',', '.')) ?? 0) * 1000).round();
  }
  return (int.tryParse(text) ?? 0) * 1000;
}

String _plainWeight(int milli) {
  final text = (milli / 1000).toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '');
  return (text.endsWith('.') ? text.substring(0, text.length - 1) : text).replaceAll('.', ',');
}

final weightEditProvider = NotifierProvider<WeightEdit, WeightEditState>(WeightEdit.new);
