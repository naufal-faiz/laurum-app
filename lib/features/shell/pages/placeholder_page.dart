import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({required this.title, super.key, this.isTab = false});
  final String title;
  final bool isTab;
  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: SingleChildScrollView(
        child: EmptyState(
          title: title,
          icon: AppIcons.receipt,
          description: 'Layar ini belum tersedia pada tahap pengembangan saat ini.',
        ),
      ),
    );
    return isTab
        ? body
        : SubScaffold(
            title: title,
            backLabel: 'Kembali',
            onBack: () => context.canPop() ? context.pop() : context.go('/antrean'),
            body: body,
          );
  }
}
