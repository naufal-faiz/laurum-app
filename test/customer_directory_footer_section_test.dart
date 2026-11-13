import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/widgets/customer_directory_footer_section.dart';

void main() {
  testWidgets('footer reports the displayed count and delegates show all at narrow width', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SizedBox(
            width: 272,
            child: CustomerDirectoryFooterSection(shown: 10, total: 48, onShowAll: () => taps++),
          ),
        ),
      ),
    );
    expect(find.text('Menampilkan 10 dari 48 pelanggan'), findsOneWidget);
    await tester.tap(find.text('Lihat semua'));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });
}
