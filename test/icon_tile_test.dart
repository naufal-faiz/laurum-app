import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/molecules/icon_tile.dart';

import '../widgetbook/molecules/icon_tile_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('IconTile keeps the preset sizes and colours', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Column(children: [IconTile.logo(), IconTile.illustration()]),
        ),
      ),
    );
    final tiles = tester.widgetList<IconTile>(find.byType(IconTile)).toList();
    expect(tiles.first.size, 38);
    expect(tiles.last.size, 118);
    expect(tester.getSize(find.byType(IconTile).first), const Size(38, 38));
    expect(tester.getSize(find.byType(IconTile).last), const Size(118, 118));
  });
  registerMoleculeGolden('icon_tile', iconTileUseCase.builder);
}
