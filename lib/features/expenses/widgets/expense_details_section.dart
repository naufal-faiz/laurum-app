import 'package:flutter/material.dart';
import 'package:laurum/core/domain/expense_category.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/state/expense_draft.dart';
import 'package:laurum/features/expenses/widgets/expense_attachment_section.dart';
import 'package:laurum/features/expenses/widgets/expense_category_section.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

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
    spacing: AppSpacing.medium,
    children: [
      const SectionHeader(title: 'Rincian pengeluaran'),
      ExpenseCategorySection(
        categories: categories,
        selectedId: draft.categoryId,
        busy: draft.busy,
        onCategory: onCategory,
        onNewCategory: onNewCategory,
      ),
      AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MenuRow(
              label: 'Tanggal',
              subtitle: Formatters.tanggal(draft.date),
              icon: AppIcons.calendar,
              compact: true,
              onTap: draft.busy ? null : onDate,
            ),
            const AppDivider(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.medium,
                children: [
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
                ],
              ),
            ),
            const AppDivider(),
            ExpenseAttachmentSection(
              photoPath: draft.photoPath,
              busy: draft.busy,
              onPhoto: onPhoto,
            ),
          ],
        ),
      ),
    ],
  );
}
