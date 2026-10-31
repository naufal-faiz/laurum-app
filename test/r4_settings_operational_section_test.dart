import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/settings/widgets/settings_operational_section.dart';

void main() {
  testWidgets('operational Section delegates routes and reflects WhatsApp connection', (
    tester,
  ) async {
    for (final connected in [true, false]) {
      final opened = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SettingsOperationalSection(
                connected: connected,
                onNavigate: opened.add,
              ),
            ),
          ),
        ),
      );
      final routes = {
        'Layanan dan tarif': '/lainnya/layanan',
        'Pengeluaran': '/lainnya/pengeluaran',
        'Printer dan struk': '/lainnya/printer',
        'Otomatisasi AI': '/lainnya/ai',
      };
      for (final entry in routes.entries) {
        await tester.ensureVisible(find.text(entry.key));
        await tester.tap(find.text(entry.key));
        expect(opened.last, entry.value);
      }
      expect(
        find.text('Integrasi WhatsApp AI • ${connected ? 'Terhubung' : 'Terputus'}'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }
  });
}
