import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(
    ProviderScope(
      child: Widgetbook.material(
        directories: const [],
        lightTheme: AppTheme.light,
        themeMode: ThemeMode.light,
        home: const Scaffold(),
      ),
    ),
  );
}
