class ExpenseDraft {
  const ExpenseDraft({
    required this.date,
    this.categoryId = '',
    this.text = '',
    this.vendor = '',
    this.note = '',
    this.photoPath,
    this.busy = false,
    this.fresh = true,
    this.error,
  });
  final DateTime date;
  final String categoryId, text, vendor, note;
  final String? photoPath, error;
  final bool busy, fresh;
  int get amount => int.tryParse(text) ?? 0;
  bool get valid => amount > 0 && categoryId.isNotEmpty && !busy;
  String? get nominalError => amount <= 0 ? 'Nominal harus lebih dari Rp0' : null;
  ExpenseDraft copyWith({
    DateTime? date,
    String? categoryId,
    String? text,
    String? vendor,
    String? note,
    String? photoPath,
    bool? busy,
    bool? fresh,
    String? error,
  }) => ExpenseDraft(
    date: date ?? this.date,
    categoryId: categoryId ?? this.categoryId,
    text: text ?? this.text,
    vendor: vendor ?? this.vendor,
    note: note ?? this.note,
    photoPath: photoPath ?? this.photoPath,
    busy: busy ?? this.busy,
    fresh: fresh ?? this.fresh,
    error: error,
  );
}
