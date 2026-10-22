import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

void main() {
  testWidgets('avatar renders variants and respects its public contract', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AppAvatar(initials: 'A', semanticLabel: 'Customer'),
        ),
      ),
    );
    expect(find.text('A'), findsOneWidget);
    expect(tester.getSize(find.byType(AppAvatar)), const Size(40, 40));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: AppAvatar(semanticLabel: 'Customer')),
      ),
    );
    expect(find.byType(AppIcon), findsOneWidget);
    expect(find.text('A'), findsNothing);
  });
}
