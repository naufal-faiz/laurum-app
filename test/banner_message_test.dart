import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

import '../widgetbook/molecules/banner_message_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('BannerMessage renders and honors callbacks', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BannerMessage(message: 'Warning', variant: BannerMessageVariant.warning),
        ),
      ),
    );
    expect(find.text('Warning'), findsOneWidget);
    expect(tester.widget<AppIcon>(find.byType(AppIcon)).icon, AppIcons.alert);
  });
  registerMoleculeGolden('banner_message', bannerMessageUseCase.builder);
}
