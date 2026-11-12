import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/customers/widgets/customer_profile_section.dart';

void main() {
  testWidgets('profile without phone keeps WhatsApp and edit callbacks reachable', (tester) async {
    var contacted = false, edited = false;
    final customer = Customer(
      id: 'c',
      ownerId: 'owner',
      createdAt: DateTime(2026),
      name: 'Pelanggan',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CustomerProfileSection(
              summary: CustomerDirectoryRow(customer, 0, 0, 0, 0, 0),
              onWhatsApp: () => contacted = true,
              onEdit: () => edited = true,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka WhatsApp'));
    expect(contacted, isTrue);
    await tester.tap(find.text('Edit profil'));
    expect(edited, isTrue);
  });
}
