import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';

class SvgTestBundle extends CachingAssetBundle {
  SvgTestBundle(this.bytes);
  final ByteData bytes;

  @override
  Future<ByteData> load(String key) async =>
      key == 'test/fixtures/test_icon.svg' ? bytes : rootBundle.load(key);
}

void main() {
  testWidgets('AppSvg loads a test-only asset with currentColor and semantics', (tester) async {
    final bytes = ByteData.sublistView(File('test/fixtures/test_icon.svg').readAsBytesSync());
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: SvgTestBundle(bytes),
        child: const MaterialApp(
          home: AppSvg(
            'test/fixtures/test_icon.svg',
            color: AppColors.primary,
            semanticLabel: 'Test asset',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect((svg.bytesLoader as SvgAssetLoader).theme?.currentColor, AppColors.primary);
    expect(svg.semanticsLabel, 'Test asset');
    expect(AppSvgs.paths, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
