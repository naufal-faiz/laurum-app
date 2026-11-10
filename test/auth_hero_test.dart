import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/organisms/auth_hero.dart';

import '../widgetbook/organisms/auth_hero_use_case.dart';
import 'organism_gallery.dart';

Widget _host(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('AuthHero compact layout shows title, subtitle and back callback', (tester) async {
    var back = 0;
    await tester.pumpWidget(
      _host(
        AuthHero(
          height: 230,
          title: 'Daftar',
          subtitle: 'Buat akun untuk mulai mengelola usaha',
          onBack: () => back++,
        ),
      ),
    );
    expect(find.text('Daftar'), findsOneWidget);
    expect(find.text('Buat akun untuk mulai mengelola usaha'), findsOneWidget);
    expect(find.byType(AppIconButton), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali'));
    expect(back, 1);
  });

  testWidgets('AuthHero tall layout renders brand and illustration slots', (tester) async {
    await tester.pumpWidget(
      _host(
        const AuthHero(
          height: 340,
          title: 'Masuk',
          subtitle: 'Kasir laundry untuk usaha rumahan',
          brand: SizedBox(key: ValueKey('brand'), width: 10, height: 10),
        ),
      ),
    );
    expect(find.byKey(const ValueKey('brand')), findsOneWidget);
    expect(find.byType(AppIconButton), findsNothing);
    expect(tester.takeException(), isNull);
  });
  registerOrganismGallery('auth_hero', authHeroUseCase.builder, height: 640);
}
