import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/widgets/service_picker_list_section.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

void main() {
  testWidgets('service section filters the query and forwards search and selection', (
    tester,
  ) async {
    ServiceItem? selected;
    String? query;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: SubScaffold(
          title: 'Pilih layanan',
          backLabel: 'Kembali',
          body: ServicePickerListSection(
            services: serviceFixtures,
            query: 'BED',
            onSearch: (value) => query = value,
            onSelect: (value) => selected = value,
          ),
        ),
      ),
    );
    expect(find.text('Bed cover'), findsOneWidget);
    expect(find.text('Cuci setrika'), findsNothing);
    expect(find.text('Jas & gaun'), findsNothing);
    await tester.tap(find.text('Bed cover'));
    expect(selected?.name, 'Bed cover');
    await tester.enterText(find.byType(TextField), 'karpet');
    expect(query, 'karpet');
  });
}
