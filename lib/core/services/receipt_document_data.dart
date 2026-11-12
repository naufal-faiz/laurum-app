class ReceiptDocumentRow {
  const ReceiptDocumentRow(
    this.label,
    this.value, {
    this.detail,
    this.valueDetail,
    this.emphasis = false,
  });
  final String label, value;
  final String? detail;
  final String? valueDetail;
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
    this.statusDetail = '',
    this.footerTitle,
  });
  final String title, status, fileName;
  final String statusDetail;
  final String? footerTitle;
  final List<String> header, footer;
  final List<List<ReceiptDocumentRow>> groups;
  final bool settled;
}
