class SyncChange {
  const SyncChange({
    required this.changeId,
    required this.table,
    required this.rowId,
    required this.op,
    required this.payload,
    this.schemaVersion = 5,
  });
  final String changeId;
  final String table;
  final String rowId;
  final String op;
  final Map<String, Object?> payload;
  final int schemaVersion;

  Map<String, Object?> toJson() => {
    'change_id': changeId,
    'table': table,
    'row_id': rowId,
    'op': op,
    'schema_version': schemaVersion,
    'payload': payload,
  };
}
