class SyncCursor {
  const SyncCursor({this.updatedAt, this.id});
  final DateTime? updatedAt;
  final String? id;

  bool get isEmpty => updatedAt == null && id == null;

  bool samePosition(SyncCursor other) => updatedAt == other.updatedAt && id == other.id;
}
