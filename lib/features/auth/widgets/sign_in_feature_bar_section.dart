import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/molecules/feature_strip.dart';

/// Static feature strip of frame `LAURUM · Masuk` (display only, no action).
class SignInFeatureBarSection extends StatelessWidget {
  const SignInFeatureBarSection({super.key});

  static const _items = [
    (icon: AppIcons.queue, label: 'Antrean rapi'),
    (icon: AppIcons.receipt, label: 'Struk otomatis'),
    (icon: AppIcons.reports, label: 'Laporan harian'),
  ];

  @override
  Widget build(BuildContext context) => const FeatureStrip(items: _items);
}
