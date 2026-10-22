import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

enum SyncState { tersimpan, menyimpan, offline, gagal }

class SyncIndicator extends StatelessWidget {
  const SyncIndicator({required this.state, super.key});
  final SyncState state;
  @override
  Widget build(BuildContext context) {
    final (label, icon, background, foreground) = switch (state) {
      SyncState.tersimpan => (
        'Tersimpan',
        AppIcons.check,
        AppColors.primaryTint,
        AppColors.primary,
      ),
      SyncState.menyimpan => ('Menyimpan', AppIcons.refresh, AppColors.chipIdle, AppColors.ink2),
      SyncState.offline => ('Offline', AppIcons.alert, AppColors.warningTint, AppColors.warningInk),
      SyncState.gagal => ('Gagal', AppIcons.alert, AppColors.errorTint, AppColors.errorInk),
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        liveRegion: true,
        child: Container(
          padding: AppMoleculeTokens.syncPadding,
          decoration: BoxDecoration(color: background, borderRadius: AppRadius.chip),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(icon, size: AppMoleculeTokens.syncIcon, color: foreground),
              const SizedBox(width: AppMoleculeTokens.smallGap),
              AppText(label, variant: AppTextVariant.label, color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}
