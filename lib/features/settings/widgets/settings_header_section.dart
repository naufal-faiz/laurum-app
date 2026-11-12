import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/organisms/app_page_header.dart';

class SettingsHeaderSection extends StatelessWidget {
  const SettingsHeaderSection({
    required this.name,
    required this.syncState,
    required this.onAccount,
    super.key,
  });
  final String name;
  final SyncState syncState;
  final VoidCallback onAccount;
  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word.characters.first.toUpperCase())
        .join();
    return AppPageHeader(
      title: 'Lainnya',
      subtitle: 'Pengaturan toko · Laurum v1.0.0',
      action: AppIconButton(
        icon: AppIcons.avatar,
        label: 'Usaha dan akun',
        initials: initials.isEmpty ? 'L' : initials,
        onPressed: onAccount,
      ),
      status: SyncIndicator(state: syncState),
    );
  }
}
