class ReceiptDocumentRow {
  const ReceiptDocumentRow(this.label, this.value, {this.detail, this.emphasis = false});
  final String label, value;
  final String? detail;
  final bool emphasis;
}

class ReceiptDocumentData {
  const ReceiptDocumentData({
    required this.title,
    required this.header,
    required this.groups,
    required this.status,
    required this.settled,
    required this.footer,
    required this.fileName,
  });
  final String title, status, fileName;
  final List<String> header, footer;
  final List<List<ReceiptDocumentRow>> groups;
  final bool settled;
}
