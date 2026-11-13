import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/printer/widgets/printer_device_list_section.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

void main() {
  testWidgets('saved printer is deduplicated and selection is disabled while busy', (tester) async {
    const saved = PrinterDevice(id: 'home', name: 'Printer rumah');
    PrinterDevice? selected;
    Future<void> pump({required bool busy}) => tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: PrinterDeviceListSection(
            devices: const [
              saved,
              PrinterDevice(id: 'other', name: 'Printer lain'),
            ],
            saved: saved,
            busy: busy,
            onSelect: (device) => selected = device,
          ),
        ),
      ),
    );
    await pump(busy: true);
    expect(find.text('Printer rumah'), findsOneWidget);
    expect(
      tester.widgetList<MenuRow>(find.byType(MenuRow)).every((row) => row.onTap == null),
      isTrue,
    );
    await pump(busy: false);
    await tester.tap(find.text('Printer rumah'));
    expect(selected, saved);
  });
}
