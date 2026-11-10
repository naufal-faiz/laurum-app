import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/organisms/welcome_banner.dart';
import 'package:widgetbook/widgetbook.dart';

final welcomeBannerUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: WelcomeBanner(
      greeting: 'Selamat datang kembali,',
      businessName: 'Shanum Laundry',
      subtitle: 'Siap untuk kembali bekerja',
      actionLabel: 'Kelola antrean',
    ),
  ),
);
