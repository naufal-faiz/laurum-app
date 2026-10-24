# REPO MAP

Dibuat otomatis oleh `dart run tool/repo_map.dart`. Jangan diedit manual.
Baca berkas ini sebagai pengganti memindai folder.

## Registry widget: 60/60 dibuat

Semua widget sudah dibuat.

## Dependensi

flutter, cupertino_icons, flutter_riverpod, go_router, equatable, intl, ionicons, flutter_svg, flutter_test, flutter_lints, widgetbook, riverpod_lint

## Berkas (jumlah baris): nama deklarasi

### lib/
- app.dart (16): LaurumApp

### lib/core/domain/
- business_profile.dart (33): BusinessProfile
- cancellation.dart (69):
- customer.dart (25): Customer
- domain_enums.dart (16): OrderStatus, PayStatus, ServiceKind, PayMethod, SavingsKind, ProposalStatus, OrderSource, RecordSyncState
- domain_record.dart (18): DomainRecord
- expense.dart (36): Expense
- expense_category.dart (19): ExpenseCategory
- money.dart (34):
- order.dart (79): Order
- order_event.dart (37): OrderEvent
- order_item.dart (41): OrderItem
- order_number_generator.dart (35): OrderNumberGenerator
- order_rules.dart (26):
- payment.dart (37): Payment
- payment_corrections.dart (42):
- proposal.dart (24): Proposal
- receipt_formatter.dart (82):
- receipt_layout.dart (77): ReceiptLayout
- receipt_settings.dart (38): ReceiptSettings
- report.dart (73):
- report_baseline.dart (13): ReportBaseline
- report_range.dart (16): ReportRange
- report_totals.dart (30): ReportTotals

### lib/core/domain/repositories/
- business_repository.dart (10): BusinessRepository
- customer_repository.dart (8): CustomerRepository
- expense_repository.dart (10): ExpenseRepository
- order_repository.dart (33): OrderRepository
- proposal_repository.dart (13): ProposalRepository
- report_repository.dart (10): ReportRepository
- savings_repository.dart (9): SavingsRepository
- service_repository.dart (8): ServiceRepository

### lib/core/domain/
- revenue_allocation.dart (29):
- savings_entry.dart (26): SavingsEntry
- savings_rules.dart (59):
- service_item.dart (38): ServiceItem
- service_revenue.dart (15): ServiceRevenue
- top_services.dart (56):

### lib/core/formatters/
- formatters.dart (40): Formatters

### lib/core/icons/
- app_icons.dart (49): AppIcons
- app_svgs.dart (4): AppSvgs

### lib/core/services/
- auth_service.dart (42): AuthService, FakeAuthService
- contact_source.dart (23): ContactItem, ContactSource, FakeContactSource
- export_service.dart (19): ExportService, FakeExportService
- external_launcher.dart (25): ExternalLauncher, FakeExternalLauncher
- photo_picker.dart (16): PhotoPicker, FakePhotoPicker
- print_service.dart (96): PrintStatus, PrinterDevice, ReceiptData, PrintService, FakePrintService
- repository_providers.dart (41): businessRepositoryProvider, customerRepositoryProvider, serviceRepositoryProvider, orderRepositoryProvider, savingsRepositoryProvider, expenseRepositoryProvider, proposalRepositoryProvider, reportRepositoryProvider
- service_providers.dart (38): printServiceProvider, externalLauncherProvider, contactSourceProvider, photoPickerProvider, exportServiceProvider, authServiceProvider, syncServiceProvider
- sync_service.dart (42): SyncServiceStatus, SyncService, FakeSyncService

### lib/core/theme/
- app_borders.dart (7): AppBorders
- app_button_styles.dart (53): AppButtonVariant, AppButtonStyles
- app_colors.dart (33): AppColors
- app_control_tokens.dart (16): AppControlTokens
- app_dimensions.dart (6): AppDimensions
- app_input_styles.dart (61): AppInputStyles
- app_molecule_styles.dart (32): AppMoleculeStyles
- app_molecule_tokens.dart (15): AppMoleculeTokens
- app_radius.dart (14): AppRadius
- app_shadows.dart (15): AppShadows
- app_spacing.dart (9): AppSpacing
- app_text_styles.dart (85): AppTextStyles
- app_theme.dart (44): AppTheme
- receipt_edge_clipper.dart (27): ReceiptEdgeClipper

### lib/features/business/data/
- business_fixtures.dart (21):
- in_memory_business_repository.dart (36): BusinessState, InMemoryBusinessRepository, inMemoryBusinessRepositoryProvider

### lib/features/customers/data/
- contact_fixtures.dart (8):
- customer_fixtures.dart (57):
- customer_history_fixtures.dart (8):
- in_memory_customer_repository.dart (76): InMemoryCustomerRepository, inMemoryCustomerRepositoryProvider
- in_memory_savings_repository.dart (48): InMemorySavingsRepository, inMemorySavingsRepositoryProvider
- savings_fixtures.dart (86):

### lib/features/expenses/data/
- expense_category_fixtures.dart (35):
- expense_fixtures.dart (10):
- in_memory_expense_repository.dart (64): InMemoryExpenseRepository, inMemoryExpenseRepositoryProvider
- prior_expense_fixtures.dart (72):
- week_expense_fixtures.dart (48):

### lib/features/orders/data/
- in_memory_order_repository.dart (91): InMemoryOrderRepository, inMemoryOrderRepositoryProvider
- order_event_fixtures.dart (26):
- order_fixture_factory.dart (26):
- order_fixtures.dart (8):
- order_history_fixtures.dart (43):
- order_item_fixtures.dart (43):
- order_queue_fixtures.dart (8):
- order_queue_process_fixtures.dart (81):
- order_queue_ready_fixtures.dart (42):
- order_store.dart (20): OrderStore
- order_store_write.dart (86):
- payment_fixtures.dart (31):

### lib/features/orders/pages/
- antrean_controller.dart (76): AntreanFilter, AntreanActionState, AntreanActions, antreanFilterProvider, antreanActionsProvider
- antrean_data.dart (68): AntreanData, antreanDataProvider
- antrean_page.dart (100): AntreanPage
- antrean_status_page.dart (69): AntreanStatusPage

### lib/features/printer/data/
- receipt_demo.dart (74):

### lib/features/printer/pages/
- bluetooth_sheet.dart (44): BluetoothSheet
- printer_connection.dart (87): PrinterConnectionController, printerConnectionProvider
- printer_connection_page.dart (79): PrinterConnectionPage
- printer_device_sheet.dart (49): PrinterDeviceSheet
- printer_page.dart (84): PrinterPage
- printer_preview_page.dart (42): PrinterPreviewPage
- printer_settings.dart (85): PrinterSettingsState, PrinterSettingsController, printerSettingsProvider
- printer_settings_page.dart (84): PrinterSettingsPage
- printer_state.dart (73): PrinterConnectionState

### lib/features/proposals/data/
- in_memory_proposal_repository.dart (63): InMemoryProposalRepository, inMemoryProposalRepositoryProvider
- proposal_fixtures.dart (31):

### lib/features/reports/data/
- in_memory_report_repository.dart (76): InMemoryReportRepository, inMemoryReportRepositoryProvider
- report_adjustments.dart (16):
- report_fixtures.dart (83):
- report_snapshot.dart (21):
- report_top_services.dart (35):

### lib/features/services/data/
- in_memory_service_repository.dart (63): InMemoryServiceRepository, inMemoryServiceRepositoryProvider
- service_fixtures.dart (67):

### lib/features/shell/pages/
- app_router.dart (49):
- placeholder_page.dart (31): PlaceholderPage
- placeholder_routes.dart (28):
- root_shell_page.dart (49): RootShellPage
- shell_state.dart (23): FakeWhatsappConnection, businessClockProvider, businessProfileProvider, shellSyncProvider, whatsappConnectionProvider

### lib/features/transactions/pages/
- add_customer_form.dart (102): AddCustomerState, AddCustomerForm, addCustomerFormProvider
- add_customer_form_page.dart (74): AddCustomerFormPage
- add_customer_sheet.dart (50): AddCustomerSheet
- cash_input_sheet.dart (76): CashInput, CashInputSheet, cashInputProvider
- checkout_item.dart (21):
- checkout_save.dart (109):
- checkout_state.dart (89): PaymentMode, CheckoutState, Checkout, checkoutControllerProvider
- contact_picker_sheet.dart (58): ContactPickerSheet, contactsProvider
- customer_picker_sheet.dart (97): CustomerPickerSheet
- discount_sheet.dart (85): DiscountInputState, DiscountInput, DiscountSheet, discountInputProvider
- payment_method_page.dart (78): PaymentMethodPage
- payment_page.dart (63): PaymentPage
- payment_quote.dart (34): PaymentQuote
- payment_savings_page.dart (65): PaymentSavingsPage
- payment_summary_page.dart (86): PaymentSummaryPage
- receipt_page.dart (90): ReceiptPage
- receipt_print_controller.dart (47): ReceiptPrintState, ReceiptPrint, receiptPrintProvider
- receipt_status_page.dart (95): ReceiptStatusPage
- receipt_view.dart (55): ReceiptView, receiptViewProvider
- service_picker_page.dart (101): ServicePickerPage
- transaction_actions.dart (22):
- transaction_customer_page.dart (49): TransactionCustomerPage
- transaction_details_page.dart (66): TransactionDetailsPage
- transaction_draft.dart (110): DraftLine, TransactionDraftState, TransactionDraft, transactionDraftProvider
- transaction_line_sheet.dart (76): TransactionLineSheet
- transaction_page.dart (66): TransactionPage
- transaction_providers.dart (32): ServiceSearch, CustomerSearch, serviceCatalogProvider, customerCatalogProvider, customerBalanceProvider, serviceSearchProvider, customerSearchProvider
- weight_edit.dart (58): WeightEditState, WeightEdit, weightEditProvider
- weight_input_sheet.dart (86): WeightInputSheet

### lib/
- main.dart (17):
- main_dummy.dart (85):

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
- app_bar_root.dart (48): AppBarRoot
- app_bar_sub.dart (54): AppBarSub
- banner_message.dart (41): BannerMessageVariant, BannerMessage
- callout_ai.dart (36): CalloutAi
- chip_bar.dart (29): ChipBar
- date_group_header.dart (41): DateGroupHeader
- empty_state.dart (48): EmptyState
- footer_bar.dart (28): FooterBar
- info_row.dart (28): InfoRow
- labeled_field.dart (35): LabeledField
- locked_row.dart (47): LockedRow
- menu_row.dart (45): MenuRow
- nominal_chips.dart (31): NominalChips
- notice_ai.dart (17): NoticeAi
- period_tabs.dart (29): PeriodTabs
- progress_row.dart (38): ProgressRow
- section_header.dart (37): SectionHeader
- stat_tile.dart (35): StatTile
- stepper_field.dart (61): StepperField
- sync_indicator.dart (46): SyncState, SyncIndicator
- toggle_row.dart (49): ToggleRow

### lib/shared/widgets/organisms/
- app_bottom_sheet.dart (86): AppBottomSheet
- bottom_nav_bar.dart (73): BottomNavBar
- confirm_modal.dart (89): ConfirmModal
- customer_row.dart (98): CustomerRow
- expense_row.dart (57): ExpenseRow
- nota_card.dart (75): NotaCard
- numpad.dart (62): NumpadVariant, Numpad
- order_card.dart (100): OrderCard
- piutang_card.dart (80): PiutangCard
- proposal_card.dart (63): ProposalCard
- receipt_preview.dart (36): ReceiptPreview
- receipt_toggle_list.dart (65): ReceiptToggleList
- report_summary.dart (109): ReportSummary
- savings_row.dart (74): SavingsRow
- service_row.dart (84): ServiceRow
- top_services.dart (106): TopServices
- weekly_bar_chart.dart (110): WeeklyBarChart

### lib/shared/widgets/templates/
- auth_scaffold.dart (20): AuthScaffold
- form_scaffold.dart (41): FormScaffold
- root_scaffold.dart (72): RootScaffold
- sheet_scaffold.dart (40): SheetScaffold
- sub_scaffold.dart (35): SubScaffold

### test/
- add_customer_test.dart (64):
- antrean_controller_test.dart (46):
- antrean_golden_test.dart (52):
- antrean_page_test.dart (57):
- antrean_states_test.dart (82):
- antrean_test_host.dart (45):
- app_avatar_test.dart (28):
- app_badge_test.dart (29):
- app_bar_root_test.dart (32):
- app_bar_sub_test.dart (26):
- app_bottom_sheet_test.dart (45):
- app_button_test.dart (44):
- app_card_test.dart (51):
- app_chip_test.dart (41):
- app_divider_test.dart (41):
- app_gap_test.dart (33):
- app_icon_button_test.dart (32):
- app_icon_test.dart (29):
- app_numpad_key_test.dart (43):
- app_router_test.dart (53):
- app_search_field_test.dart (66):
- app_skeleton_test.dart (32):
- app_status_text_test.dart (26):
- app_svg_test.dart (42): SvgTestBundle
- app_switch_test.dart (42):
- app_text_field_test.dart (70):
- app_text_test.dart (39):
- atom_gallery_test.dart (75):
- auth_scaffold_test.dart (22):
- banner_message_test.dart (23):
- bottom_nav_bar_test.dart (36):
- callout_ai_test.dart (20):
- checkout_controller_test.dart (83):
- chip_bar_test.dart (30):
- confirm_modal_test.dart (74):
- customer_row_test.dart (39):
- date_group_header_test.dart (24):
- domain_baseline_test.dart (51):
- domain_cancel_test.dart (74):
- domain_flow_test.dart (53):
- domain_models_1_test.dart (38):
- domain_models_2_test.dart (42):
- domain_models_3_test.dart (28):
- domain_money_test.dart (48):
- domain_order_models_test.dart (30):
- domain_report_test.dart (77):
- domain_samples.dart (89):
- domain_savings_test.dart (87):
- domain_schedule_test.dart (35):
- domain_top_services_test.dart (34):
- dummy_cancellation_ledger_test.dart (35):
- dummy_catalog_integration_test.dart (56):
- dummy_data_integration_test.dart (64):
- dummy_fixture_integrity_test.dart (51):
- dummy_live_creation_test.dart (59):
- dummy_order_atomicity_test.dart (77):
- dummy_provider_notifications_test.dart (71):
- dummy_report_baseline_test.dart (39):
- dummy_report_mutation_test.dart (52):
- dummy_repository_regression_test.dart (52):
- dummy_savings_integration_test.dart (49):
- empty_state_test.dart (28):
- expense_row_test.dart (34):
- footer_bar_test.dart (30):
- form_scaffold_test.dart (33):
- formatters_test.dart (40):
- info_row_test.dart (25):
- labeled_field_test.dart (29):
- locked_row_test.dart (25):
- menu_row_test.dart (25):
- molecule_gallery.dart (35):
- nominal_chips_test.dart (25):
- nota_card_test.dart (37):
- notice_ai_test.dart (20):
- numpad_test.dart (47):
- order_card_test.dart (40):
- order_number_generator_test.dart (34):
- organism_gallery.dart (54):
- payment_page_test.dart (59):
- period_tabs_test.dart (29):
- piutang_card_test.dart (43):
- platform_services_test.dart (83):
- printer_page_test.dart (100):
- printer_service_test.dart (42):
- progress_row_test.dart (23):
- proposal_card_test.dart (41):
- receipt_fixtures.dart (86):
- receipt_formatter_settings_test.dart (31):
- receipt_formatter_test.dart (70):
- receipt_page_test.dart (67):
- receipt_preview_test.dart (28):
- receipt_template_lines.dart (28):
- receipt_toggle_list_test.dart (37):
- report_summary_test.dart (36):
- root_scaffold_test.dart (39):
- savings_row_test.dart (33):
- section_header_test.dart (26):
- service_picker_test.dart (54):
- service_row_test.dart (41):
- sheet_scaffold_test.dart (37):
- stat_tile_test.dart (24):
- stepper_field_test.dart (33):
- sub_scaffold_test.dart (32):
- sync_indicator_test.dart (23):
- template_gallery.dart (54):
- toggle_row_test.dart (25):
- top_services_test.dart (30):
- transaction_draft_test.dart (43):
- transaction_golden_test.dart (118):
- transaction_page_test.dart (97):
- weekly_bar_chart_test.dart (30):
- widget_test.dart (22):

### tool/
- check_all.dart (37): Step
- check_arch.dart (121): Rule, Registry
- pen_frame.dart (42):
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
- main.dart (76):

### widgetbook/molecules/
- app_bar_root_use_case.dart (25):
- app_bar_sub_use_case.dart (26):
- banner_message_use_case.dart (19):
- callout_ai_use_case.dart (20):
- chip_bar_use_case.dart (23):
- date_group_header_use_case.dart (20):
- empty_state_use_case.dart (26):
- footer_bar_use_case.dart (35):
- info_row_use_case.dart (20):
- labeled_field_use_case.dart (40):
- locked_row_use_case.dart (25):
- m1.dart (21):
- m2.dart (17):
- m3.dart (19):
- menu_row_use_case.dart (26):
- nominal_chips_use_case.dart (25):
- notice_ai_use_case.dart (18):
- period_tabs_use_case.dart (24):
- progress_row_use_case.dart (19):
- section_header_use_case.dart (24):
- stat_tile_use_case.dart (25):
- stepper_field_use_case.dart (39):
- sync_indicator_use_case.dart (18):
- toggle_row_use_case.dart (27):

### widgetbook/organisms/
- app_bottom_sheet_use_case.dart (35):
- bottom_nav_bar_use_case.dart (17):
- confirm_modal_use_case.dart (35):
- customer_row_use_case.dart (44):
- expense_row_use_case.dart (27):
- fixture_labels.dart (10):
- nota_card_use_case.dart (51):
- numpad_use_case.dart (23):
- o1.dart (23):
- o2.dart (21):
- order_card_use_case.dart (55):
- piutang_card_use_case.dart (37):
- proposal_card_use_case.dart (30):
- receipt_preview_use_case.dart (106):
- receipt_toggle_list_use_case.dart (36):
- report_summary_use_case.dart (18):
- savings_row_use_case.dart (43):
- service_row_use_case.dart (34):
- top_services_use_case.dart (13):
- weekly_bar_chart_use_case.dart (17):

### widgetbook/templates/
- auth_scaffold_use_case.dart (45):
- form_scaffold_use_case.dart (40):
- root_scaffold_use_case.dart (48):
- sheet_scaffold_use_case.dart (59):
- sub_scaffold_use_case.dart (40):
- templates.dart (15):
