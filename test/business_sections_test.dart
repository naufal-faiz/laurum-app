import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/business/widgets/business_preview_section.dart';
import 'package:laurum/features/business/widgets/business_printer_section.dart';

void main() {
  testWidgets('printer section shows the shortcut and delegates the tap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BusinessPrinterSection(onTap: () => taps++),
        ),
      ),
    );
    expect(find.text('STRUK & PRINTER'), findsOneWidget);
    expect(find.text('Printer dan struk'), findsOneWidget);
    await tester.tap(find.text('Printer dan struk'));
    expect(taps, 1);
  });
  testWidgets('preview section shows the receipt values from the draft', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BusinessPreviewSection(
            name: 'Berkah Laundry',
            address: 'Jl. Melati No. 4',
            phone: '081234567890',
            footer: 'Terima kasih',
          ),
        ),
      ),
    );
    expect(find.text('PRATINJAU STRUK'), findsOneWidget);
    expect(find.text('BERKAH LAUNDRY'), findsOneWidget);
    expect(find.text('Jl. Melati No. 4'), findsOneWidget);
    expect(find.text('0812-3456-7890'), findsOneWidget);
    expect(find.text('Terima kasih'), findsOneWidget);
  });
}
