# REPO MAP

Dibuat otomatis oleh `dart run tool/repo_map.dart`. Jangan diedit manual.
Baca berkas ini sebagai pengganti memindai folder.

## Registry widget: 31/60 dibuat

Belum dibuat: AppBarRoot, AppBarSub, AppBottomSheet, AuthScaffold, BottomNavBar, ChipBar, ConfirmModal, CustomerRow, ExpenseRow, FooterBar, FormScaffold, NominalChips, NotaCard, Numpad, OrderCard, PeriodTabs, PiutangCard, ProposalCard, ReceiptPreview, ReceiptToggleList, ReportSummary, RootScaffold, SavingsRow, ServiceRow, SheetScaffold, StepperField, SubScaffold, TopServices, WeeklyBarChart

## Dependensi

flutter, cupertino_icons, flutter_riverpod, go_router, equatable, intl, ionicons, flutter_svg, flutter_test, flutter_lints, widgetbook, riverpod_lint

## Berkas (jumlah baris): nama deklarasi

### lib/
- app.dart (14): LaurumApp

### lib/core/formatters/
- formatters.dart (37): Formatters

### lib/core/icons/
- app_icons.dart (49): AppIcons
- app_svgs.dart (4): AppSvgs

### lib/core/theme/
- app_borders.dart (7): AppBorders
- app_button_styles.dart (53): AppButtonVariant, AppButtonStyles
- app_colors.dart (33): AppColors
- app_control_tokens.dart (16): AppControlTokens
- app_dimensions.dart (6): AppDimensions
- app_input_styles.dart (61): AppInputStyles
- app_molecule_tokens.dart (15): AppMoleculeTokens
- app_radius.dart (14): AppRadius
- app_shadows.dart (15): AppShadows
- app_spacing.dart (9): AppSpacing
- app_text_styles.dart (85): AppTextStyles
- app_theme.dart (44): AppTheme

### lib/
- main.dart (10):
- main_dummy.dart (4):

### lib/shared/widgets/atoms/
- app_avatar.dart (36): AppAvatar
- app_badge.dart (31): AppBadgeVariant, AppBadge
- app_button.dart (54): AppButton
- app_card.dart (47): AppCardRail, AppCard
- app_chip.dart (40): AppChip
- app_divider.dart (16): AppDivider
- app_gap.dart (19): AppGap
- app_icon.dart (27): AppIcon
- app_icon_button.dart (40): AppIconButton
- app_numpad_key.dart (54): AppNumpadKeyValue, AppNumpadKey
- app_search_field.dart (88): AppSearchField, _AppSearchFieldState
- app_skeleton.dart (25): AppSkeleton
- app_status_text.dart (22): AppStatusTextVariant, AppStatusText
- app_svg.dart (29): AppSvg
- app_switch.dart (50): AppSwitch
- app_text.dart (66): AppTextVariant, AppText
- app_text_field.dart (88): AppTextField, _AppTextFieldState

### lib/shared/widgets/molecules/
- banner_message.dart (41): BannerMessageVariant, BannerMessage
- callout_ai.dart (36): CalloutAi
- date_group_header.dart (41): DateGroupHeader
- empty_state.dart (48): EmptyState
- info_row.dart (28): InfoRow
- labeled_field.dart (35): LabeledField
- locked_row.dart (49): LockedRow
- menu_row.dart (45): MenuRow
- notice_ai.dart (17): NoticeAi
- progress_row.dart (35): ProgressRow
- section_header.dart (37): SectionHeader
- stat_tile.dart (35): StatTile
- sync_indicator.dart (46): SyncState, SyncIndicator
- toggle_row.dart (49): ToggleRow

### test/
- app_avatar_test.dart (28):
- app_badge_test.dart (29):
- app_button_test.dart (44):
- app_card_test.dart (51):
- app_chip_test.dart (41):
- app_divider_test.dart (41):
- app_gap_test.dart (33):
- app_icon_button_test.dart (32):
- app_icon_test.dart (29):
- app_numpad_key_test.dart (43):
- app_search_field_test.dart (66):
- app_skeleton_test.dart (32):
- app_status_text_test.dart (26):
- app_svg_test.dart (42): SvgTestBundle
- app_switch_test.dart (42):
- app_text_field_test.dart (70):
- app_text_test.dart (39):
- atom_gallery_test.dart (75):
- banner_message_test.dart (23):
- callout_ai_test.dart (20):
- date_group_header_test.dart (24):
- empty_state_test.dart (28):
- formatters_test.dart (40):
- info_row_test.dart (25):
- labeled_field_test.dart (29):
- locked_row_test.dart (25):
- menu_row_test.dart (25):
- molecule_gallery.dart (35):
- notice_ai_test.dart (20):
- progress_row_test.dart (23):
- section_header_test.dart (26):
- stat_tile_test.dart (24):
- sync_indicator_test.dart (23):
- toggle_row_test.dart (25):
- widget_test.dart (22):

### tool/
- check_all.dart (37): Step
- check_arch.dart (121): Rule, Registry
- pen_frame.dart (27):
- repo_map.dart (100):

### widgetbook/atoms/
- app_avatar_use_case.dart (19):
- app_badge_use_case.dart (22):
- app_button_use_case.dart (29):
- app_card_use_case.dart (25):
- app_chip_use_case.dart (21):
- app_divider_use_case.dart (34):
- app_gap_use_case.dart (28):
- app_icon_button_use_case.dart (20):
- app_icon_use_case.dart (31):
- app_numpad_key_use_case.dart (37):
- app_search_field_use_case.dart (25):
- app_skeleton_use_case.dart (22):
- app_status_text_use_case.dart (22):
- app_switch_use_case.dart (21):
- app_text_field_use_case.dart (24):
- app_text_use_case.dart (21):

### widgetbook/
- main.dart (64):

### widgetbook/molecules/
- banner_message_use_case.dart (19):
- callout_ai_use_case.dart (20):
- date_group_header_use_case.dart (20):
- empty_state_use_case.dart (26):
- info_row_use_case.dart (20):
- labeled_field_use_case.dart (40):
- locked_row_use_case.dart (19):
- m1.dart (21):
- m2.dart (17):
- menu_row_use_case.dart (26):
- notice_ai_use_case.dart (18):
- progress_row_use_case.dart (19):
- section_header_use_case.dart (24):
- stat_tile_use_case.dart (25):
- sync_indicator_use_case.dart (18):
- toggle_row_use_case.dart (25):
