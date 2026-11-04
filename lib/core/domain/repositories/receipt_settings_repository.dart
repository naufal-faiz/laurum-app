import 'package:laurum/core/domain/receipt_settings.dart';

abstract class ReceiptSettingsRepository {
  Future<ReceiptSettings> getReceiptSettings();
  Future<void> saveReceiptSettings(ReceiptSettings settings);
}
