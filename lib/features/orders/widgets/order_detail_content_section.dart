import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/widgets/order_detail_body_section.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';

class OrderDetailContentSection extends StatelessWidget {
  const OrderDetailContentSection({
    required this.data,
    required this.loading,
    required this.failed,
    required this.onRetry,
    required this.onWhatsApp,
    required this.onRecord,
    this.useOrderStatus = true,
    this.error,
    this.notice,
    super.key,
  });
  final OrderDetailData? data;
  final bool loading, failed, useOrderStatus;
  final String? error, notice;
  final VoidCallback onRetry, onWhatsApp, onRecord;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [for (var i = 0; i < 5; i++) const AppSkeleton()],
      );
    }
    if (failed) {
      return EmptyState(
        title: 'Gagal memuat order',
        icon: AppIcons.alert,
        actionLabel: 'Coba lagi',
        onAction: onRetry,
      );
    }
    if (data == null) {
      return const EmptyState(title: 'Order tidak ditemukan', icon: AppIcons.receipt);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.screenPadding,
      children: [
        if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
        if (notice != null) BannerMessage(message: notice!),
        OrderDetailBodySection(
          data: data!,
          useOrderStatus: useOrderStatus,
          onWhatsApp: onWhatsApp,
          onRecord: onRecord,
        ),
      ],
    );
  }
}
