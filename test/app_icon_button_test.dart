import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
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
  testWidgets('hero variant draws a 36 dp circle inside a 44 dp target', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppIconButton(
            variant: AppIconButtonVariant.hero,
            iconAsset: AppSvgs.cursorBack,
            label: 'Kembali',
            onPressed: () => taps++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Kembali'), findsOneWidget);
    expect(tester.getSize(find.byType(IconButton)), const Size(44, 44));
    final circleFinder = find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).shape == BoxShape.circle,
    );
    final decoration = tester.widget<DecoratedBox>(circleFinder).decoration as BoxDecoration;
    expect(tester.getSize(circleFinder), const Size.square(36));
    expect(decoration.color, AppColors.illustration);
    expect((decoration.border! as Border).top.color, AppColors.backBorder);
    expect(tester.getSize(find.byType(AppSvg)), const Size(18, 18));
    await tester.tap(find.byType(IconButton));
    expect(taps, 1);
  });
}
