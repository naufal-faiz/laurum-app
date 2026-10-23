abstract class ExportService {
  Future<String> exportReport({
    required String fileName,
    required String content,
  });
}

class FakeExportService implements ExportService {
  final List<({String fileName, String content})> exportedReports = [];

  @override
  Future<String> exportReport({
    required String fileName,
    required String content,
  }) async {
    exportedReports.add((fileName: fileName, content: content));
    return '/dummy/exports/$fileName';
  }
}
