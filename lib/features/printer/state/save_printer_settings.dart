import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/domain/repositories/business_repository.dart';
import 'package:laurum/core/domain/repositories/receipt_settings_repository.dart';
import 'package:laurum/core/services/transaction_runner.dart';
import 'package:laurum/features/printer/state/printer_state.dart';

Future<BusinessProfile> savePrinterSettings(
  BusinessRepository business,
  ReceiptSettingsRepository receipts,
  TransactionRunner runner,
  ReceiptSettings settings,
  BusinessProfile draft,
) => runner.run(() async {
  // Only the footer/note belong to this form; preserve newer business settings.
  final latest = await business.getProfile();
  final profile = copyProfile(
    latest,
    receiptFooter: draft.receiptFooter,
    receiptNote: draft.receiptNote,
  );
  await receipts.saveReceiptSettings(settings);
  await business.saveProfile(profile);
  return profile;
});
