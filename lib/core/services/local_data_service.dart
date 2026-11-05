abstract class LocalDataService {
  Future<void> deleteLocalData();
  // The caller invokes this only after the surrounding transaction commits.
  Future<void> finishDelete() async {}
}

class FakeLocalDataService implements LocalDataService {
  FakeLocalDataService({this.onDelete});
  final Future<void> Function()? onDelete;
  int deleteCallCount = 0;
  @override
  Future<void> finishDelete() async {}
  @override
  Future<void> deleteLocalData() async {
    await onDelete?.call();
    deleteCallCount++;
  }
}
