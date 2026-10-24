import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/templates/auth_scaffold.dart';

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
  registerTemplateGallery('auth_scaffold', authScaffoldUseCase.builder);
}
