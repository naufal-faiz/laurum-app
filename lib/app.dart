import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_theme.dart';

class LaurumApp extends StatelessWidget {
  const LaurumApp({required this.router, super.key});
  final GoRouter router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Laurum',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    routerConfig: router,
  );
}
