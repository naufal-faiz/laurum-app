import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

class ServiceFormFooterSection extends StatelessWidget {
  const ServiceFormFooterSection({
    required this.busy,
    required this.onSave,
    required this.onCancel,
    super.key,
    this.isEdit = false,
  });
  final bool busy, isEdit;
  final VoidCallback onSave, onCancel;

  @override
  Widget build(BuildContext context) {
    final cancel = FocusTraversalOrder(
      order: const NumericFocusOrder(1),
      child: AppButton(
        'Batal',
        size: AppButtonSize.large,
        variant: AppButtonVariant.actionOutline,
        onPressed: busy ? null : onCancel,
      ),
    );
    final save = FocusTraversalOrder(
      order: const NumericFocusOrder(0),
      child: AppButton(
        isEdit ? 'Simpan perubahan' : 'Simpan layanan',
        icon: AppIcons.check,
        size: AppButtonSize.large,
        onPressed: busy ? null : onSave,
      ),
    );
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
        child: LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth < AppSpacing.touchTarget * 6 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.2
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.small,
                  children: [cancel, save],
                )
              : Row(
                  spacing: AppSpacing.medium,
                  children: [
                    Expanded(flex: 3, child: cancel),
                    Expanded(flex: 5, child: save),
                  ],
                ),
        ),
      ),
    );
  }
}
