import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/services/state/service_edit_state.dart';
import 'package:laurum/features/services/widgets/service_information_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'service_create_test_host.dart';

void main() {
  testWidgets('ServiceInformationSection preserves field order, errors, digit filters and busy', (
    tester,
  ) async {
    String? name, price;
    await pumpServiceSection(
      tester,
      ServiceInformationSection(
        state: const ServiceEditState(
          nameError: 'Nama layanan wajib diisi.',
          priceError: 'Harga harus lebih dari Rp0.',
        ),
        onName: (value) => name = value,
        onPrice: (value) => price = value,
        onKind: (_) {},
      ),
    );
    expect(find.text('Nama layanan wajib diisi.'), findsOneWidget);
    expect(find.text('Harga harus lebih dari Rp0.'), findsOneWidget);
    final fields = find.byType(TextField);
    await tester.enterText(fields.first, 'Karpet');
    await tester.enterText(fields.at(1), '12a3');
    expect(name, 'Karpet');
    expect(price, '123');
    expect(tester.widget<AppTextField>(find.byType(AppTextField).at(1)).prefixText, 'Rp ');
    await pumpServiceSection(
      tester,
      ServiceInformationSection(
        state: const ServiceEditState(busy: true, priceText: '7500'),
        onName: (_) {},
        onPrice: (_) {},
        onKind: (_) {},
      ),
    );
    expect(
      tester.widgetList<AppTextField>(find.byType(AppTextField)).every((field) => !field.enabled),
      isTrue,
    );
    expect(tester.widget<AppTextField>(find.byType(AppTextField).at(1)).selectAllOnFocus, isTrue);
  });
}
