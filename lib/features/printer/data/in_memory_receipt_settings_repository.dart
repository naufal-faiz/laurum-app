import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/domain/repositories/business_repository.dart';
import 'package:laurum/core/domain/repositories/receipt_settings_repository.dart';

// Share the existing transactional store, notifications and account cleanup.
class InMemoryReceiptSettingsRepository implements ReceiptSettingsRepository {
  InMemoryReceiptSettingsRepository(this.business);
  final BusinessRepository business;
  @override
  Future<ReceiptSettings> getReceiptSettings() => business.getReceiptSettings();
  @override
  Future<void> saveReceiptSettings(ReceiptSettings settings) =>
      business.saveReceiptSettings(settings);
}
