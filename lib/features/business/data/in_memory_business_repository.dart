import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/domain/repositories/business_repository.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

typedef BusinessState = ({BusinessProfile profile, ReceiptSettings settings});

class InMemoryBusinessRepository extends Notifier<BusinessState> implements BusinessRepository {
  @override
  BusinessState build() => (
    profile: businessProfileFixture,
    settings: receiptSettingsFixture,
  );

  @override
  Future<BusinessProfile> getProfile() async => state.profile;

  @override
  Future<void> saveProfile(BusinessProfile profile) async {
    state = (profile: profile, settings: state.settings);
  }

  @override
  Future<ReceiptSettings> getReceiptSettings() async => state.settings;

  @override
  Future<void> saveReceiptSettings(ReceiptSettings settings) async {
    state = (profile: state.profile, settings: settings);
  }
}

final inMemoryBusinessRepositoryProvider =
    NotifierProvider<InMemoryBusinessRepository, BusinessState>(
      InMemoryBusinessRepository.new,
    );
