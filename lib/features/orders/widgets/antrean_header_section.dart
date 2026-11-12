import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/organisms/app_page_header.dart';

class AntreanHeaderSection extends StatelessWidget {
  const AntreanHeaderSection({
    required this.searchOpen,
    required this.onSearch,
    this.total = 0,
    this.reviewCount = 0,
    this.syncState = SyncState.tersimpan,
    super.key,
  });
  final bool searchOpen;
  final VoidCallback onSearch;
  final int total, reviewCount;
  final SyncState syncState;
  @override
  Widget build(BuildContext context) => AppPageHeader(
    title: 'Antrean',
    subtitle: '$total order aktif · $reviewCount perlu dicek',
    action: AppIconButton(
      icon: searchOpen ? AppIcons.close : AppIcons.search,
      label: searchOpen ? 'Tutup pencarian' : 'Cari antrean',
      onPressed: onSearch,
    ),
    status: SyncIndicator(state: syncState),
  );
}
