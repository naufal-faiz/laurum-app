import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/nota_history_controller.dart';
import 'package:laurum/features/orders/pages/nota_history_data.dart';
import 'package:laurum/features/orders/pages/nota_history_list_page.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/footer_bar.dart';

class NotaHistoryPage extends ConsumerWidget {
  const NotaHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(notaHistoryProvider);
    final data = snapshot.value;
    return Column(
      children: [
        Expanded(
          child: data == null
              ? (snapshot.hasError
                    ? Center(
                        child: EmptyState(
                          title: 'Gagal memuat nota',
                          icon: AppIcons.alert,
                          description: 'Periksa koneksi dan coba lagi.',
                          actionLabel: 'Coba lagi',
                          onAction: () => ref.invalidate(notaHistoryProvider),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(AppSpacing.screenPadding),
                        children: [
                          for (var i = 0; i < 4; i++)
                            const Padding(
                              padding: EdgeInsets.only(bottom: AppSpacing.cardGap),
                              child: AppSkeleton(height: AppSpacing.touchTarget * 2),
                            ),
                        ],
                      ))
              : NotaHistoryListPage(
                  data: data,
                  filter: ref.watch(notaFilterProvider),
                  search: ref.watch(notaSearchProvider),
                  today: ref.watch(businessClockProvider)(),
                  onSearch: ref.read(notaSearchProvider.notifier).set,
                  onFilter: ref.read(notaFilterProvider.notifier).select,
                  onOpen: (order) => context.push('/order/${order.id}'),
                ),
        ),
        FooterBar(
          child: AppButton('Transaksi baru', onPressed: () => context.push('/transaksi/baru')),
        ),
      ],
    );
  }
}
