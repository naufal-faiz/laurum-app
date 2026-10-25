import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void configureKeyboardTest(WidgetTester tester, {Size size = const Size(390, 844)}) {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = size * 2;
  tester.view.padding = const FakeViewPadding(top: 48, bottom: 48);
  tester.view.viewPadding = const FakeViewPadding(top: 48, bottom: 48);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetViewInsets);
  addTearDown(tester.view.resetPadding);
  addTearDown(tester.view.resetViewPadding);
}

Future<void> expectKeyboardVisible(
  WidgetTester tester, {
  required Finder field,
  required Finder save,
}) async {
  await tester.ensureVisible(field);
  await tester.showKeyboard(field);
  tester.view.viewInsets = FakeViewPadding(bottom: 300 * tester.view.devicePixelRatio);
  await tester.pumpAndSettle();
  final editable = tester.widget<EditableText>(
    find.descendant(
      of: field,
      matching: find.byType(EditableText),
    ),
  );
  expect(editable.focusNode.hasFocus, isTrue);
  final keyboardTop = tester.view.physicalSize.height / tester.view.devicePixelRatio - 300;
  for (final target in [field, save]) {
    final rect = tester.getRect(target);
    expect(rect.top, greaterThanOrEqualTo(0));
    expect(rect.bottom, lessThanOrEqualTo(keyboardTop));
    expect(target.hitTestable(), findsOneWidget);
  }
  final fieldRect = tester.getRect(field);
  final viewport = tester.getRect(
    find.ancestor(of: field, matching: find.byType(SingleChildScrollView)).first,
  );
  expect(fieldRect.top, greaterThanOrEqualTo(viewport.top));
  expect(fieldRect.bottom, lessThanOrEqualTo(viewport.bottom));
  expect(fieldRect.bottom, lessThanOrEqualTo(tester.getRect(save).top));
  expect(tester.takeException(), isNull);
}
