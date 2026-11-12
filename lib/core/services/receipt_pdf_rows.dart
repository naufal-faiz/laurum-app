import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:pdf/widgets.dart' as pw;

List<pw.Widget> receiptPdfRows(
  List<ReceiptDocumentRow> rows, {
  required pw.TextStyle normal,
  required pw.TextStyle strong,
  required pw.TextStyle caption,
}) => [
  for (final row in rows)
    pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: AppSpacing.xxsmall),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(row.label, style: row.emphasis ? strong : normal),
                if (row.detail != null) pw.Text(row.detail!, style: caption),
              ],
            ),
          ),
          pw.SizedBox(width: AppSpacing.medium),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Text(
                  row.value,
                  textAlign: pw.TextAlign.right,
                  style: row.emphasis ? strong : normal,
                ),
                if (row.valueDetail != null)
                  pw.Text(
                    row.valueDetail!,
                    textAlign: pw.TextAlign.right,
                    maxLines: 2,
                    style: caption,
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
];
