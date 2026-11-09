import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';

void main() {
  testWidgets('icon_button renders variants and respects its public contract', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppIconButton(icon: AppIcons.person, label: 'Open', onPressed: () => taps++),
        ),
      ),
    );
    expect(tester.getSize(find.byType(IconButton)), const Size(48, 48));
    expect(tester.widget<IconButton>(find.byType(IconButton)).style?.backgroundColor, isNull);
    expect(find.byTooltip('Open'), findsOneWidget);
    expect(find.byType(AppIcon), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    expect(taps, 1);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AppIconButton(icon: AppIcons.person, label: 'Disabled'),
        ),
      ),
    );
    expect(tester.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);
  });
  testWidgets('icon_button renders a bundled brand asset instead of a glyph', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AppIconButton(iconAsset: AppSvgs.whatsapp, label: 'WhatsApp'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppSvg), findsOneWidget);
    expect(find.byType(AppIcon), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
