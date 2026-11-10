import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/organisms/auth_card.dart';

import '../widgetbook/organisms/auth_card_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('AuthCard stacks its children with a 12 dp gap', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AuthCard(children: [Text('Atas'), Text('Bawah')]),
        ),
      ),
    );
    final gap =
        tester.getTopLeft(find.text('Bawah')).dy - tester.getBottomLeft(find.text('Atas')).dy;
    expect(gap, 12);
  });
  registerOrganismGallery('auth_card', authCardUseCase.builder, height: 400);
}
