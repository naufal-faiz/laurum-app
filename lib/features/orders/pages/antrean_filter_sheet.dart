import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/antrean_filter_view.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

class AntreanFilterSheet extends ConsumerWidget {
  const AntreanFilterSheet({super.key});
  static Future<void> show(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return AppBottomSheet.show<void>(
      context: context,
      title: 'Filter status',
      child: const AntreanFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(antreanDataProvider).value;
    final useStatus = ref.watch(businessProfileProvider).value?.useOrderStatus ?? true;
    final filters = AntreanFilterView(ref.watch(antreanFilterProvider), useOrderStatus: useStatus);
    if (data == null) return const AppSkeleton();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.small,
          children: [
            for (final value in filters.values)
              AppButton(
                data.chips[value],
                variant: value == filters.selectedValue
                    ? AppButtonVariant.action
                    : AppButtonVariant.actionOutline,
                onPressed: () {
                  ref.read(antreanFilterProvider.notifier).select(value);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
