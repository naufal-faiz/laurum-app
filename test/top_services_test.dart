import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/reports/data/report_samples.dart';
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
            child: TopServices(services: weekTopServicesSamples),
          ),
        ),
      ),
    );
    expect(find.text('Layanan terlaris'), findsOneWidget);
    expect(find.text('Cuci setrika'), findsOneWidget);
    expect(find.text('33,5 kg'), findsOneWidget);
    expect(find.text('Rp301.500'), findsOneWidget);
    expect(find.text('51% pendapatan'), findsOneWidget);
    expect(find.text('Cuci kering lipat'), findsOneWidget);
  });
  registerOrganismGallery('top_services', topServicesUseCase.builder, height: 700);
}
