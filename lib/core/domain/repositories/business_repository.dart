import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/repositories/receipt_settings_repository.dart';

// Receipt methods remain available as a compatibility bridge for older callers.
abstract class BusinessRepository implements ReceiptSettingsRepository {
  Future<BusinessProfile> getProfile();
  Future<void> saveProfile(BusinessProfile profile);
}
