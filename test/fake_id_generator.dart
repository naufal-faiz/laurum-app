import 'package:laurum/core/domain/id_generator.dart';

class FakeIdGenerator extends IdGenerator {
  FakeIdGenerator({this.derivedValues = const {}, this.newValues = const []});
  final Map<String, String> derivedValues;
  final List<String> newValues;
  int _sequence = 0;
  void reset() => _sequence = 0;
  @override
  String newId() {
    final index = _sequence++;
    return index < newValues.length
        ? newValues[index]
        : '00000000-0000-4000-8000-${_sequence.toString().padLeft(12, '0')}';
  }

  @override
  String derived(String parentId, String label) =>
      derivedValues['$parentId/$label'] ?? super.derived(parentId, label);
}
