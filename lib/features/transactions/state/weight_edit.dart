import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

typedef WeightEditState = ({String serviceId, String text, int milli});

class WeightEdit extends Notifier<WeightEditState> {
  @override
  WeightEditState build() => (serviceId: '', text: '', milli: 0);

  void start(DraftLine line) {
    final text = line.service.kind == ServiceKind.kiloan
        ? _plainWeight(line.qtyMilli)
        : '${line.qtyMilli ~/ 1000}';
    state = (serviceId: line.service.id, text: text, milli: line.qtyMilli);
  }

  void key(AppNumpadKeyValue key) {
    final line = ref.read(transactionDraftProvider).lineFor(state.serviceId);
    if (line == null) return;
    final value = state.text;
    final String text;
    if (key == AppNumpadKeyValue.decimal) {
      text = value.contains(',') ? value : (value.isEmpty ? '0,' : '$value,');
    } else if (key == AppNumpadKeyValue.backspace) {
      text = value.isEmpty ? '' : value.substring(0, value.length - 1);
    } else if (key == AppNumpadKeyValue.tripleZero) {
      text = value == '0' || value.isEmpty ? '0' : '${value}000';
    } else {
      text = value == '0' ? key.label : (value.length < 6 ? '$value${key.label}' : value);
    }
    state = (serviceId: state.serviceId, text: text, milli: _milliFor(text, line));
  }

  void add(int deltaMilli) {
    final next = state.milli + deltaMilli;
    state = (
      serviceId: state.serviceId,
      text: _plainWeight(next < 500 ? 500 : next),
      milli: next < 500 ? 500 : next,
    );
  }
}

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
