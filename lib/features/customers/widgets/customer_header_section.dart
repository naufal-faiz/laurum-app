import 'package:flutter/material.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/organisms/app_page_header.dart';

class CustomerHeaderSection extends StatelessWidget {
  const CustomerHeaderSection({
    required this.count,
    required this.syncState,
    required this.onAccount,
    super.key,
  });
  final int? count;
  final SyncState syncState;
  final VoidCallback onAccount;
  @override
  Widget build(BuildContext context) => AppPageHeader(
    title: 'Pelanggan',
    subtitle: count == null ? '' : '$count pelanggan',
    status: SyncIndicator(state: syncState),
  );
}
