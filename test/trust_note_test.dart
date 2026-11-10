import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/molecules/trust_note.dart';

import '../widgetbook/molecules/trust_note_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('TrustNote shows the privacy icon and its text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: TrustNote(text: 'Data kamu aman & terenkripsi'),
        ),
      ),
    );
    expect(find.byType(AppIcon), findsOneWidget);
    expect(find.text('Data kamu aman & terenkripsi'), findsOneWidget);
  });
  registerMoleculeGolden('trust_note', trustNoteUseCase.builder);
}
