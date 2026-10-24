import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/top_services.dart';

import '../widgetbook/organisms/top_services_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('TopServices renders weekly ranking and shares', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: TopServices(services: weekTopServicesFixtures),
          ),
        ),
      ),
    );
    expect(find.text('Layanan terlaris'), findsOneWidget);
    expect(find.text('Cuci setrika'), findsOneWidget);
    expect(find.text('98 kg'), findsOneWidget);
    expect(find.text('Rp882.000'), findsOneWidget);
    expect(find.text('49% pendapatan'), findsOneWidget);
    expect(find.text('Pendapatan lainnya'), findsOneWidget);
  });
  registerOrganismGallery('top_services', topServicesUseCase.builder, height: 700);
}
