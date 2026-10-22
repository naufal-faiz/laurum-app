import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_theme.dart';

class LaurumApp extends StatelessWidget {
  const LaurumApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Laurum',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const Scaffold(),
  );
}
