class ReportRangeDraft {
  const ReportRangeDraft({
    required this.firstDate,
    required this.lastDate,
    required this.month,
    this.start,
    this.end,
  });
  final DateTime firstDate, lastDate, month;
  final DateTime? start, end;
  bool get canApply => start != null && end != null;

  ReportRangeDraft withDates({DateTime? start, DateTime? end, DateTime? month}) => ReportRangeDraft(
    firstDate: firstDate,
    lastDate: lastDate,
    month: month ?? this.month,
    start: start,
    end: end,
  );
}
