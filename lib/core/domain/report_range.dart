import 'package:equatable/equatable.dart';

class ReportRange extends Equatable {
  ReportRange(this.start, this.end) {
    if (start.isUtc || end.isUtc || !end.isAfter(start)) throw ArgumentError('Invalid WIB range');
  }
  final DateTime start, end;
  // Half-open interval, expressed as WIB wall time.
  bool contains(DateTime value) {
    if (value.isUtc) throw ArgumentError('Supply WIB local wall time');
    return !value.isBefore(start) && value.isBefore(end);
  }

  @override
  List<Object?> get props => [start, end];
}
