import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/services/state/service_edit_state.dart';
import 'package:laurum/features/services/widgets/service_create_form_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'service_create_test_host.dart';

void main() {
  testWidgets('ServiceCreateFormSection keeps server error, empty inputs and all form groups', (
    tester,
  ) async {
    await pumpServiceSection(
      tester,
      ServiceCreateFormSection(
        state: const ServiceEditState(notice: 'Layanan gagal disimpan. Coba lagi.'),
        onName: (_) {},
        onPrice: (_) {},
        onKind: (_) {},
        onDuration: (_) {},
        onActive: (_) {},
      ),
    );
    expect(find.text('Layanan gagal disimpan. Coba lagi.'), findsOneWidget);
    expect(find.text('Informasi layanan'), findsOneWidget);
    expect(find.text('Durasi & status'), findsOneWidget);
    expect(tester.widgetList<AppTextField>(find.byType(AppTextField)).map((field) => field.label), [
      'Nama layanan',
      'Harga',
    ]);
    expect(
      tester
          .widgetList<TextField>(find.byType(TextField))
          .every((field) => field.controller!.text.isEmpty),
      isTrue,
    );
  });
}
