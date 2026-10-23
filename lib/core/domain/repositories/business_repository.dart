import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/receipt_settings.dart';

abstract class BusinessRepository {
  Future<BusinessProfile> getProfile();
  Future<void> saveProfile(BusinessProfile profile);

  Future<ReceiptSettings> getReceiptSettings();
  Future<void> saveReceiptSettings(ReceiptSettings settings);
}
