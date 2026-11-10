import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/templates/auth_scaffold.dart';

import '../widgetbook/templates/auth_scaffold_hero_use_case.dart';
import '../widgetbook/templates/auth_scaffold_use_case.dart';
import 'template_gallery.dart';

void main() {
  testWidgets('AuthScaffold renders its content without an app bar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const AuthScaffold(child: AppText('Laurum')),
      ),
    );
    expect(find.text('Laurum'), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
  });
  testWidgets('AuthScaffold places the child below the hero at contentTop', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const AuthScaffold(
          hero: SizedBox(key: ValueKey('hero'), height: 230),
          contentTop: 200,
          child: AppText('Kartu'),
        ),
      ),
    );
    expect(find.byKey(const ValueKey('hero')), findsOneWidget);
    expect(tester.getTopLeft(find.byType(AppText)).dy, 200);
  });
  registerTemplateGallery('auth_scaffold', authScaffoldUseCase.builder);
  registerTemplateGallery('auth_scaffold_hero', authScaffoldHeroUseCase.builder);
}
