import 'package:flutter/services.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> receiptPdf(ReceiptDocumentData data) async {
  final fallback = pw.Font.ttf(await rootBundle.load('assets/fonts/IBMPlexMono-Regular.ttf'));
  final primary = PdfColor.fromInt(AppColors.primaryInk.toARGB32());
  final theme = pw.ThemeData.withFont(
    base: pw.Font.helvetica(),
    bold: pw.Font.helveticaBold(),
    fontFallback: [fallback],
  );
  final normal = theme.defaultTextStyle.copyWith(fontSize: AppTextStyles.caption.fontSize);
  final strong = normal.copyWith(color: primary, fontWeight: pw.FontWeight.bold);
  final caption = normal.copyWith(color: PdfColor.fromInt(AppColors.ink3.toARGB32()));
  final border = PdfColor.fromInt(AppColors.border.toARGB32());
  final document = pw.Document();
  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a5,
      margin: const pw.EdgeInsets.all(AppSpacing.xlarge),
      theme: theme,
      build: (_) => [
        pw.Center(
          child: pw.Text(
            data.title,
            style: strong.copyWith(fontSize: AppTextStyles.section.fontSize),
          ),
        ),
        for (final line in data.header) pw.Center(child: pw.Text(line, style: caption)),
        for (final rows in data.groups) ...[
          pw.Divider(color: border),
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
                    child: pw.Text(
                      row.value,
                      textAlign: pw.TextAlign.right,
                      style: row.emphasis ? strong : normal,
                    ),
                  ),
                ],
              ),
            ),
        ],
        pw.Divider(color: border),
        pw.Container(
          padding: const pw.EdgeInsets.all(AppSpacing.medium),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(
              (data.settled ? AppColors.successTint : AppColors.warningTint).toARGB32(),
            ),
            borderRadius: pw.BorderRadius.circular(AppRadius.card.topLeft.x),
          ),
          child: pw.Text(
            data.status,
            style: normal.copyWith(
              color: PdfColor.fromInt(
                (data.settled ? AppColors.successInk : AppColors.warningInk).toARGB32(),
              ),
            ),
          ),
        ),
        for (final line in data.footer)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: AppSpacing.small),
            child: pw.Center(
              child: pw.Text(line, textAlign: pw.TextAlign.center, style: normal),
            ),
          ),
      ],
    ),
  );
  return document.save();
}
