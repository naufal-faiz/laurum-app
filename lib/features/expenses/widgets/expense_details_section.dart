import 'package:flutter/material.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/state/expense_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class ExpenseDetailsSection extends StatelessWidget {
  const ExpenseDetailsSection({
    required this.draft,
    required this.categories,
    required this.onCategory,
    required this.onNewCategory,
    required this.onDate,
    required this.onVendor,
    required this.onNote,
    required this.onPhoto,
    super.key,
  });
  final ExpenseDraft draft;
  final List<ExpenseCategory> categories;
  final ValueChanged<String> onCategory, onVendor, onNote;
  final VoidCallback onNewCategory, onDate, onPhoto;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const AppText('Kategori pengeluaran', variant: AppTextVariant.label),
      ChipBar(
        labels: categories.map((c) => c.name).toList(),
        selectedIndex: categories.any((c) => c.id == draft.categoryId)
            ? categories.indexWhere((c) => c.id == draft.categoryId)
            : null,
        onSelected: draft.busy ? null : (i) => onCategory(categories[i].id),
      ),
      AppButton(
        'Kategori baru',
        variant: AppButtonVariant.actionOutline,
        icon: AppIcons.add,
        onPressed: draft.busy ? null : onNewCategory,
      ),
      const AppText('Tanggal transaksi', variant: AppTextVariant.label),
      AppButton(
        Formatters.tanggal(draft.date),
        variant: AppButtonVariant.actionOutline,
        icon: AppIcons.calendar,
        onPressed: draft.busy ? null : onDate,
      ),
      LabeledField(
        label: 'Vendor / toko',
        child: AppTextField(
          label: 'Vendor / toko',
          value: draft.vendor,
          onChanged: onVendor,
          selectAllOnFocus: true,
          enabled: !draft.busy,
        ),
      ),
      LabeledField(
        label: 'Catatan / rincian keperluan',
        child: AppTextField(
          label: 'Catatan / rincian keperluan',
          value: draft.note,
          onChanged: onNote,
          maxLines: 3,
          selectAllOnFocus: true,
          enabled: !draft.busy,
        ),
      ),
      const AppText('Foto struk / nota toko', variant: AppTextVariant.label),
      AppText(draft.photoPath == null ? 'Belum dilampirkan (opsional)' : 'Foto dilampirkan'),
      AppButton(
        'Lampirkan',
        variant: AppButtonVariant.actionOutline,
        onPressed: draft.busy ? null : onPhoto,
      ),
    ],
  );
}
