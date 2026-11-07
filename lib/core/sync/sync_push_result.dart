enum SyncGroupStatus { committed, rejected, staged }

class SyncChangeResult {
  const SyncChangeResult({required this.changeId, required this.status, this.code});
  final String changeId;
  final String status;
  final String? code;
  bool get ok => status == 'ok';
}

class SyncPushResult {
  const SyncPushResult({
    required this.groupId,
    required this.status,
    this.code,
    this.results = const [],
    this.received,
    this.expected,
  });
  final String groupId;
  final SyncGroupStatus status;
  final String? code;
  final List<SyncChangeResult> results;
  final int? received;
  final int? expected;

  Set<String> get acknowledged => {
    for (final result in results)
      if (result.ok) result.changeId,
  };

  Map<String, Object?> toJson() => {
    'group_id': groupId,
    'status': status.name,
    if (code != null) 'code': code,
    if (received != null) 'received': received,
    if (expected != null) 'expected': expected,
    'results': [
      for (final result in results)
        {
          'change_id': result.changeId,
          'status': result.status,
          if (result.code != null) 'code': result.code,
        },
    ],
  };
}
