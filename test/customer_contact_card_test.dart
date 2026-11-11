import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/organisms/customer_contact_card.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('contact data and action wrap at 320 dp/$scale', (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var calls = 0;
      final person = customerFixtures.first;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: CustomerContactCard(
                  name: person.name,
                  phone: person.phone,
                  address: person.address,
                  badge: const AppBadge('Belum terdaftar', variant: AppBadgeVariant.menungguJemput),
                  onContact: () => calls++,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text(person.name), findsOneWidget);
      expect(find.text(Formatters.telepon(person.phone)), findsOneWidget);
      expect(find.text(person.address), findsOneWidget);
      expect(find.text('Belum terdaftar'), findsOneWidget);
      await tester.tap(find.text('Buka WhatsApp'));
      expect(calls, 1);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('contact can remain disabled or be omitted without exposing action', (tester) async {
    final person = customerFixtures.first;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomerContactCard(
            name: person.name,
            phone: person.phone,
          ),
        ),
      ),
    );
    expect(
      tester.widget<TextButton>(find.widgetWithText(TextButton, 'Buka WhatsApp')).onPressed,
      isNull,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomerContactCard(
            name: person.name,
            phone: '',
            showContact: false,
          ),
        ),
      ),
    );
    expect(find.text('Buka WhatsApp'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
