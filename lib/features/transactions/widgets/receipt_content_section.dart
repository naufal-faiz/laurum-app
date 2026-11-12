import 'package:flutter/material.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/receipt_document.dart';
import 'package:laurum/features/transactions/state/receipt_download.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/features/transactions/widgets/receipt_links_section.dart';
import 'package:laurum/features/transactions/widgets/receipt_status_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/organisms/receipt_document.dart';

class ReceiptContentSection extends StatelessWidget {
  const ReceiptContentSection({
    required this.view,
    required this.printState,
    required this.download,
    required this.printerStatus,
    required this.printerName,
    required this.onRetry,
    required this.onSettings,
    required this.onOrder,
    this.onRecord,
    super.key,
  });
  final ReceiptView view;
  final ReceiptPrintState printState;
  final ReceiptDownloadState download;
  final PrintStatus printerStatus;
  final String? printerName;
  final VoidCallback onRetry, onSettings, onOrder;
  final VoidCallback? onRecord;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.medium,
    children: [
      ReceiptStatusSection(
        view: view,
        printState: printState,
        printerStatus: printerStatus,
        printerName: printerName,
        onRetry: onRetry,
        onSettings: onSettings,
      ),
      const AppText('Pratinjau struk', variant: AppTextVariant.label),
      Center(
        child: SizedBox(
          width: view.settings.paperMm == 80 ? 384 : 320,
          child: ReceiptDocument(data: receiptDocument(view)),
        ),
      ),
      ReceiptLinksSection(busy: printState.printing, onOrder: onOrder, onRecord: onRecord),
      if (download.error != null)
        BannerMessage(message: download.error!, variant: BannerMessageVariant.error),
      if (download.notice != null) BannerMessage(message: download.notice!),
    ],
  );
}
