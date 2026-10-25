import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/widgets/order_edit_customer_section.dart';
import 'package:laurum/features/transactions/pages/transaction_line_sheet.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class OrderEditBodySection extends ConsumerWidget {
  const OrderEditBodySection({
    required this.orderId,
    required this.order,
    required this.details,
    super.key,
    this.error,
  });
  final String orderId;
  final Order order;
  final Widget details;
  final String? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transactionDraftProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
        if (order.source == OrderSource.whatsappAi)
          const BannerMessage(
            message: 'Order dari WhatsApp: isi berat setelah cucian ditimbang.',
          ),
        OrderEditCustomerSection(customerId: order.customerId),
        SectionHeader(title: 'Layanan', subtitle: '${draft.itemCount} layanan di nota'),
        AppButton(
          draft.lines.isEmpty ? 'Pilih layanan' : 'Tambah layanan lain',
          variant: AppButtonVariant.actionOutline,
          icon: AppIcons.add,
          onPressed: () => context.push('/order/$orderId/edit/layanan'),
        ),
        for (final line in draft.lines)
          MenuRow(
            label: line.service.name,
            subtitle: '${line.quantityLabel} · ${Formatters.rupiah(line.total)}',
            icon: AppIcons.service,
            onTap: () => TransactionLineSheet.show(context, ref, line.service.id),
          ),
        details,
      ],
    );
  }
}
