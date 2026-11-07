class SyncTransportException implements Exception {
  const SyncTransportException(this.code);
  final String code;

  @override
  String toString() => 'SyncTransportException($code)';
}
