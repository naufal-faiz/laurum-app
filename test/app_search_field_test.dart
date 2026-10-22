import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';

void main() {
  testWidgets('search exposes clear, submits, resets and syncs without losing selection', (
    tester,
  ) async {
    final changes = <String>[];
    String? submitted;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppSearchField(
            label: 'Search',
            clearLabel: 'Clear',
            onChanged: changes.add,
            onSubmitted: (value) => submitted = value,
          ),
        ),
      ),
    );
    final field = find.byType(TextField);
    final controller = tester.widget<TextField>(field).controller!;
    expect(find.byTooltip('Clear'), findsNothing);
    await tester.enterText(field, 'query');
    await tester.pump();
    expect(find.byTooltip('Clear'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    expect(submitted, 'query');
    await tester.tap(find.byTooltip('Clear'));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(changes, ['query', '']);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AppSearchField(label: 'Search', clearLabel: 'Clear', value: 'external'),
        ),
      ),
    );
    expect(controller.text, 'external');
    controller.selection = const TextSelection.collapsed(offset: 2);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AppSearchField(
            label: 'Search',
            clearLabel: 'Clear',
            value: 'external',
            enabled: false,
          ),
        ),
      ),
    );
    expect(controller.selection.baseOffset, 2);
    expect(tester.widget<TextField>(field).enabled, isFalse);
    expect(tester.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);
    await tester.pumpWidget(const SizedBox());
    expect(() => controller.addListener(() {}), throwsFlutterError);
  });
}
