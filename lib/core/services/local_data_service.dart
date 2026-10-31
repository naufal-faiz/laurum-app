abstract class LocalDataService {
  Future<void> deleteLocalData();
}

class FakeLocalDataService implements LocalDataService {
  FakeLocalDataService({this.onDelete});
  final Future<void> Function()? onDelete;
  int deleteCallCount = 0;
  @override
  Future<void> deleteLocalData() async {
    await onDelete?.call();
    deleteCallCount++;
  }
}
