import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/features/printer/state/printer_state.dart';

void main() {
  test('legacy profiles and DATA MASTER default to status tracking enabled', () {
    final profile = BusinessProfile(
      id: 'business',
      ownerId: 'owner',
      createdAt: DateTime(2026),
      name: 'Laundry',
    );
    expect(profile.useOrderStatus, isTrue);
    expect(businessProfileFixture.useOrderStatus, isTrue);
  });

  test('mode copy is immutable, participates in equality and preserves metadata', () {
    final original = BusinessProfile(
      id: 'business',
      ownerId: 'owner',
      createdAt: DateTime(2026),
      name: 'Laundry',
      address: 'Alamat',
      phone: '081234567890',
      receiptFooter: 'Footer',
      receiptNote: 'Note',
      updatedAt: DateTime(2026, 10),
      syncState: RecordSyncState.synced,
      deletedAt: DateTime(2026, 10, 2),
    );
    final disabled = original.withOrderStatus(enabled: false);
    expect(disabled.useOrderStatus, isFalse);
    expect(original.useOrderStatus, isTrue);
    expect(disabled, isNot(original));
    expect(disabled.withOrderStatus(enabled: true), original);
    expect(disabled.id, original.id);
    expect(disabled.ownerId, original.ownerId);
    expect(disabled.createdAt, original.createdAt);
    expect(disabled.updatedAt, original.updatedAt);
    expect(disabled.syncState, original.syncState);
    expect(disabled.deletedAt, original.deletedAt);
    final at = DateTime(2026, 10, 30);
    expect(original.withOrderStatus(enabled: false, updatedAt: at).updatedAt, at);
  });

  test('editing receipt text retains disabled order status mode', () {
    final original = businessProfileFixture.withOrderStatus(enabled: false);
    final edited = copyProfile(original, receiptFooter: 'Footer baru', receiptNote: 'Catatan baru');
    expect(edited.useOrderStatus, isFalse);
    expect(edited.receiptFooter, 'Footer baru');
    expect(edited.receiptNote, 'Catatan baru');
    expect(edited.name, original.name);
    expect(edited.phone, original.phone);
  });
}
