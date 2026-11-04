import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/organisms/weekly_bar_chart.dart';

import '../widgetbook/organisms/weekly_bar_chart_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('WeeklyBarChart renders past days and dashed future days', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: WeeklyBarChart(
            labels: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
            amounts: [0, 0, 248000, 164000, 177000, null, null],
            averageLabel: 'Rata-rata Rp117.800/hari',
            peakLabel: 'Puncak: Rabu',
          ),
        ),
      ),
    );
    expect(find.text('Aktivitas omzet harian'), findsOneWidget);
    expect(find.text('248k'), findsOneWidget);
    expect(find.text('—'), findsNWidgets(2));
    expect(find.text('Sab'), findsOneWidget);
  });
  registerOrganismGallery('weekly_bar_chart', weeklyBarChartUseCase.builder, height: 500);
}
