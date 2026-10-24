import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

import '../widgetbook/templates/sub_scaffold_use_case.dart';
import 'template_gallery.dart';

void main() {
  testWidgets('SubScaffold renders app bar, trailing, and back action', (tester) async {
    var backs = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: SubScaffold(
          title: 'Detail order',
          backLabel: 'Kembali',
          onBack: () => backs++,
          trailing: const AppText('Ubah'),
          body: const AppText('Isi halaman'),
        ),
      ),
    );
    expect(find.text('Detail order'), findsOneWidget);
    expect(find.text('Ubah'), findsOneWidget);
    expect(find.text('Isi halaman'), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali'));
    expect(backs, 1);
  });
  registerTemplateGallery('sub_scaffold', subScaffoldUseCases.first.builder);
}
