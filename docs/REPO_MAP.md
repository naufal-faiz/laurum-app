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
- business_profile.dart (50): BusinessProfile
- cancellation.dart (69):
- customer.dart (25): Customer
- domain_enums.dart (16): OrderStatus, PayStatus, ServiceKind, PayMethod, SavingsKind, ProposalStatus, OrderSource, RecordSyncState
- domain_record.dart (18): DomainRecord
- expense.dart (36): Expense
- expense_category.dart (19): ExpenseCategory
- money.dart (34):
- order.dart (84): Order
- order_event.dart (37): OrderEvent
- order_item.dart (41): OrderItem
- order_number_generator.dart (35): OrderNumberGenerator
- order_rules.dart (43):
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
- order_repository.dart (35): OrderRepository
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
- formatters.dart (43): Formatters

### lib/core/icons/
- app_icons.dart (49): AppIcons
- app_svgs.dart (4): AppSvgs

### lib/core/services/
- auth_service.dart (42): AuthService, FakeAuthService
- contact_source.dart (31): ContactItem, ContactSource, ContactPermissionDenied, FakeContactSource
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
- app_dimensions.dart (8): AppDimensions
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

### lib/features/business/pages/
- business_info_page.dart (96): BusinessInfoPage

### lib/features/business/state/
- business_info_controller.dart (73): BusinessInfoController, businessInfoProvider
- business_info_state.dart (40): BusinessInfoState

### lib/features/customers/data/
- contact_fixtures.dart (8):
- customer_fixtures.dart (57):
- customer_history_fixtures.dart (8):
- in_memory_customer_repository.dart (76): InMemoryCustomerRepository, inMemoryCustomerRepositoryProvider
- in_memory_savings_repository.dart (48): InMemorySavingsRepository, inMemorySavingsRepositoryProvider
- savings_fixtures.dart (86):

### lib/features/customers/pages/
- customer_deposit_page.dart (71): CustomerDepositPage
- customer_detail_page.dart (53): CustomerDetailPage
- customer_directory_page.dart (65): CustomerDirectoryPage
- customer_edit_sheet.dart (68): CustomerEditSheet
- customer_import_page.dart (67): CustomerImportPage
- customer_savings_history_page.dart (63): CustomerSavingsHistoryPage

### lib/features/customers/state/
- customer_deposit_controller.dart (79): CustomerDepositController, customerDepositProvider
- customer_deposit_state.dart (39): CustomerDepositState
- customer_detail_data.dart (51): CustomerMovement, CustomerDetailData, customerDetailProvider
- customer_directory_controller.dart (20): CustomerDirectoryFilter, CustomerDirectorySearch, customerDirectoryFilterProvider, customerDirectorySearchProvider
- customer_directory_data.dart (83): CustomerDirectoryRow, customerSummariesProvider, customerDirectoryProvider
- customer_edit_controller.dart (90): CustomerEditController, customerEditProvider
- customer_edit_state.dart (36): CustomerEditState
- customer_import_controller.dart (66): CustomerImportState, CustomerImportSelection, customerImportSelectionProvider
- customer_import_data.dart (53): ContactImportRow, ContactImportData, contactImportProvider
- customer_savings_controller.dart (14): CustomerSavingsFilter, customerSavingsFilterProvider
- customer_savings_data.dart (59): CustomerSavingsData, customerSavingsProvider

### lib/features/customers/widgets/
- customer_deposit_form_section.dart (88): CustomerDepositFormSection
- customer_directory_list_section.dart (86): CustomerDirectoryListSection
- customer_edit_form_section.dart (65): CustomerEditFormSection
- customer_import_list_section.dart (94): CustomerImportListSection
- customer_orders_section.dart (36): CustomerOrdersSection
- customer_profile_section.dart (75): CustomerProfileSection
- customer_savings_header_section.dart (66): CustomerSavingsHeaderSection
- customer_savings_list_section.dart (58): CustomerSavingsListSection
- customer_savings_section.dart (54): CustomerSavingsSection

### lib/features/expenses/data/
- expense_category_fixtures.dart (35):
- expense_fixtures.dart (10):
- in_memory_expense_repository.dart (64): InMemoryExpenseRepository, inMemoryExpenseRepositoryProvider
- prior_expense_fixtures.dart (72):
- week_expense_fixtures.dart (48):

### lib/features/orders/data/
- in_memory_order_repository.dart (99): InMemoryOrderRepository, inMemoryOrderRepositoryProvider
- order_event_fixtures.dart (26):
- order_fixture_factory.dart (26):
- order_fixtures.dart (8):
- order_history_fixtures.dart (43):
- order_item_fixtures.dart (43):
- order_queue_fixtures.dart (8):
- order_queue_process_fixtures.dart (81):
- order_queue_ready_fixtures.dart (42):
- order_store.dart (20): OrderStore
- order_store_write.dart (89):
- payment_fixtures.dart (31):

### lib/features/orders/pages/
- antrean_page.dart (95): AntreanPage
- nota_history_page.dart (67): NotaHistoryPage
- order_cancel_flow.dart (24):
- order_completion_flow.dart (36):
- order_detail_menu_flow.dart (22):
- order_detail_page.dart (100): OrderDetailPage
- order_edit_page.dart (84): OrderEditPage
- order_menu_sheet.dart (60): OrderMenuAction, OrderMenuSheet
- order_status_sheet.dart (59): OrderStatusSheet
- payment_record_sheet.dart (78): PaymentRecordSheet

### lib/features/orders/state/
- antrean_controller.dart (84): AntreanFilter, AntreanActionState, AntreanActions, antreanFilterProvider, antreanActionsProvider
- antrean_data.dart (68): AntreanData, antreanDataProvider
- antrean_filter_view.dart (9): AntreanFilterView
- nota_history_controller.dart (20): NotaFilter, NotaSearch, notaFilterProvider, notaSearchProvider
- nota_history_data.dart (69): NotaHistoryData, notaHistoryProvider
- order_completion_controller.dart (57): OrderCompletionState, OrderCompletion, orderCompletionProvider
- order_completion_save.dart (47):
- order_detail_controller.dart (85): OrderActionState, OrderActions, orderActionsProvider
- order_detail_data.dart (98): ActivityEntry, OrderDetailData, orderDetailProvider
- order_edit_controller.dart (101): OrderEditState, OrderEdit, orderEditProvider
- order_edit_item.dart (25):
- order_edit_order.dart (21):
- order_payment_controller.dart (81): OrderPaymentState, OrderPaymentAction, orderPaymentProvider
- payment_draft.dart (33): PaymentDraftState, PaymentDraft, paymentDraftProvider

### lib/features/orders/widgets/
- antrean_orders_section.dart (50): AntreanOrdersSection
- antrean_status_section.dart (74): AntreanStatusSection
- nota_history_list_section.dart (97): NotaHistoryListSection
- order_customer_section.dart (56): OrderCustomerSection
- order_detail_body_section.dart (35): OrderDetailBodySection
- order_detail_content_section.dart (63): OrderDetailContentSection
- order_detail_footer_section.dart (83): OrderDetailFooterSection
- order_edit_body_section.dart (61): OrderEditBodySection
- order_edit_customer_section.dart (43): OrderEditCustomerSection
- order_items_section.dart (76): OrderItemsSection
- order_payment_section.dart (44): OrderPaymentSection
- order_summary_section.dart (56): OrderSummarySection
- order_timeline_section.dart (55): OrderTimelineSection

### lib/features/printer/data/
- receipt_demo.dart (74):

### lib/features/printer/pages/
- bluetooth_sheet.dart (44): BluetoothSheet
- printer_device_sheet.dart (49): PrinterDeviceSheet
- printer_page.dart (84): PrinterPage

### lib/features/printer/state/
- printer_connection.dart (87): PrinterConnectionController, printerConnectionProvider
- printer_settings.dart (85): PrinterSettingsState, PrinterSettingsController, printerSettingsProvider
- printer_state.dart (74): PrinterConnectionState

### lib/features/printer/widgets/
- printer_connection_section.dart (79): PrinterConnectionSection
- printer_preview_section.dart (42): PrinterPreviewSection
- printer_settings_section.dart (84): PrinterSettingsSection

### lib/features/proposals/data/
- in_memory_proposal_repository.dart (63): InMemoryProposalRepository, inMemoryProposalRepositoryProvider
- proposal_fixtures.dart (31):

### lib/features/reports/data/
- in_memory_report_repository.dart (76): InMemoryReportRepository, inMemoryReportRepositoryProvider
- report_adjustments.dart (16):
- report_daily.dart (25):
- report_daily_fixtures.dart (2):
- report_fixtures.dart (83):
- report_snapshot.dart (21):
- report_top_services.dart (35):

### lib/features/reports/pages/
- outstanding_page.dart (59): OutstandingPage
- report_page.dart (90): ReportPage

### lib/features/reports/state/
- outstanding_controller.dart (95): PaymentRecordState, PaymentRecordController, paymentRecordProvider
- outstanding_data.dart (68): OutstandingRow, OutstandingListData, OutstandingFilter, outstandingListProvider, outstandingFilterProvider
- report_export.dart (62): ReportExportState, ReportExport, reportExportProvider
- report_period.dart (22): ReportPeriod, reportPeriodProvider
- report_view.dart (66): ReportView, reportViewProvider

### lib/features/reports/widgets/
- outstanding_list_section.dart (77): OutstandingListSection
- report_body_section.dart (63): ReportBodySection

### lib/features/services/data/
- in_memory_service_repository.dart (63): InMemoryServiceRepository, inMemoryServiceRepositoryProvider
- service_fixtures.dart (67):

### lib/features/services/pages/
- service_directory_page.dart (71): ServiceDirectoryPage
- service_edit_page.dart (73): ServiceEditPage

### lib/features/services/state/
- service_copy.dart (25):
- service_directory_data.dart (15):
- service_directory_providers.dart (17): ServiceDirectorySearch, serviceDirectoryProvider, serviceDirectorySearchProvider
- service_edit_controller.dart (104): ServiceEditController, serviceEditProvider
- service_edit_state.dart (55): ServiceEditState

### lib/features/services/widgets/
- service_directory_content_section.dart (68): ServiceDirectoryContentSection
- service_directory_list_section.dart (37): ServiceDirectoryListSection
- service_edit_fields_section.dart (100): ServiceEditFieldsSection

### lib/features/settings/pages/
- settings_page.dart (43): SettingsPage

### lib/features/settings/state/
- order_status_setting.dart (31): OrderStatusSettingState, OrderStatusSetting, orderStatusSettingProvider

### lib/features/settings/widgets/
- settings_account_section.dart (43): SettingsAccountSection
- settings_menu_section.dart (71): SettingsMenuSection
- settings_operational_section.dart (59): SettingsOperationalSection

### lib/features/shell/pages/
- app_router.dart (100):
- lainnya_routes.dart (16):
- placeholder_page.dart (31): PlaceholderPage
- placeholder_routes.dart (17):
- root_shell_page.dart (48): RootShellPage

### lib/features/shell/state/
- shell_state.dart (23): FakeWhatsappConnection, businessClockProvider, businessProfileProvider, shellSyncProvider, whatsappConnectionProvider

### lib/features/transactions/pages/
- add_customer_sheet.dart (51): AddCustomerSheet
- cash_input_sheet.dart (57): CashInputSheet
- contact_picker_sheet.dart (58): ContactPickerSheet, contactsProvider
- customer_picker_sheet.dart (97): CustomerPickerSheet
- discount_sheet.dart (74): DiscountSheet
- payment_page.dart (63): PaymentPage
- receipt_page.dart (90): ReceiptPage
- service_picker_page.dart (54): ServicePickerPage
- transaction_leave_flow.dart (22):
- transaction_line_sheet.dart (76): TransactionLineSheet
- transaction_page.dart (87): TransactionPage
- weight_input_sheet.dart (91): WeightInputSheet

### lib/features/transactions/state/
- add_customer_form.dart (102): AddCustomerState, AddCustomerForm, addCustomerFormProvider
- cash_input.dart (23): CashInput, cashInputProvider
- checkout_item.dart (33):
- checkout_save.dart (100):
- checkout_state.dart (89): PaymentMode, CheckoutState, Checkout, checkoutControllerProvider
- discount_input.dart (19): DiscountInputState, DiscountInput, discountInputProvider
- payment_quote.dart (34): PaymentQuote
- receipt_print_controller.dart (59): ReceiptPrintState, ReceiptPrint, receiptPrintProvider
- receipt_view.dart (55): ReceiptView, receiptViewProvider
- transaction_draft.dart (110): DraftLine, TransactionDraftState, TransactionDraft, transactionDraftProvider
- transaction_providers.dart (32): ServiceSearch, CustomerSearch, serviceCatalogProvider, customerCatalogProvider, customerBalanceProvider, serviceSearchProvider, customerSearchProvider
- weight_edit.dart (79): WeightEditState, WeightEdit, weightEditProvider

### lib/features/transactions/widgets/
- add_customer_form_section.dart (77): AddCustomerFormSection
- payment_method_section.dart (78): PaymentMethodSection
- payment_savings_section.dart (65): PaymentSavingsSection
- payment_summary_section.dart (86): PaymentSummarySection
- receipt_status_section.dart (95): ReceiptStatusSection
- service_picker_list_section.dart (84): ServicePickerListSection
- transaction_customer_section.dart (57): TransactionCustomerSection
- transaction_details_section.dart (66): TransactionDetailsSection

### lib/
- main.dart (17):
- main_dummy.dart (90):

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
- app_text_field.dart (99): AppTextField, _AppTextFieldState

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
- app_bottom_sheet.dart (93): AppBottomSheet
- bottom_nav_bar.dart (103): BottomNavBar
- confirm_modal.dart (89): ConfirmModal
- customer_row.dart (98): CustomerRow
- expense_row.dart (57): ExpenseRow
- nota_card.dart (75): NotaCard
- numpad.dart (62): NumpadVariant, Numpad
- order_card.dart (99): OrderCard
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
- form_scaffold.dart (44): FormScaffold
- root_scaffold.dart (49): RootScaffold
- sheet_scaffold.dart (40): SheetScaffold
- sub_scaffold.dart (62): SubScaffold

### test/
- add_customer_test.dart (64):
- antrean_controller_test.dart (67):
- antrean_golden_test.dart (52):
- antrean_page_test.dart (57):
- antrean_states_test.dart (82):
- antrean_test_host.dart (50):
- antrean_test_host_test.dart (22):
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
- app_router_test.dart (64):
- app_search_field_test.dart (66):
- app_skeleton_test.dart (32):
- app_status_text_test.dart (26):
- app_svg_test.dart (42): SvgTestBundle
- app_switch_test.dart (42):
- app_text_field_focus_test.dart (53):
- app_text_field_test.dart (70):
- app_text_test.dart (39):
- atom_gallery_test.dart (75):
- auth_scaffold_test.dart (22):
- banner_message_test.dart (23):
- bottom_nav_bar_test.dart (85):
- business_info_page_test.dart (50):
- callout_ai_test.dart (20):
- checkout_controller_test.dart (83):
- chip_bar_test.dart (30):
- confirm_modal_test.dart (74):
- customer_deposit_page_test.dart (50):
- customer_detail_data_test.dart (61):
- customer_detail_page_test.dart (86):
- customer_detail_states_test.dart (60):
- customer_directory_data_test.dart (39):
- customer_directory_states_test.dart (64):
- customer_directory_test.dart (67):
- customer_import_page_test.dart (68):
- customer_row_test.dart (39):
- customer_savings_section_test.dart (48):
- date_group_header_test.dart (24):
- discount_input_test.dart (118):
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
- input_templates_keyboard_test.dart (72):
- keyboard_audit_test.dart (145):
- keyboard_test_helper.dart (52):
- labeled_field_test.dart (29):
- locked_row_test.dart (25):
- menu_row_test.dart (25):
- molecule_gallery.dart (35):
- nominal_chips_test.dart (25):
- nominal_input_test.dart (77):
- nota_card_test.dart (37):
- nota_history_test.dart (67):
- notice_ai_test.dart (20):
- numpad_test.dart (47):
- order_actions_test.dart (72):
- order_card_test.dart (89):
- order_detail_test.dart (89):
- order_edit_test.dart (80):
- order_number_generator_test.dart (34):
- organism_gallery.dart (54):
- outstanding_page_test.dart (38):
- payment_page_test.dart (59):
- period_tabs_test.dart (29):
- piutang_card_test.dart (43):
- platform_services_test.dart (83):
- printer_page_test.dart (100):
- printer_service_test.dart (42):
- progress_row_test.dart (23):
- proposal_card_test.dart (41):
- r2_navigation_test.dart (56):
- r3_customer_creation_test.dart (55):
- r3_service_creation_test.dart (50):
- r3_service_picker_keyboard_test.dart (36):
- r4_antrean_action_test.dart (26):
- r4_antrean_filter_test.dart (30):
- r4_antrean_flow_test.dart (65):
- r4_antrean_orders_section_test.dart (60):
- r4_antrean_page_test.dart (70):
- r4_business_profile_test.dart (57):
- r4_completion_guards_test.dart (72):
- r4_completion_test_host.dart (38): CompletionPrinter
- r4_detail_completion_test.dart (84):
- r4_detail_print_failure_test.dart (57):
- r4_finish_flow_test.dart (83):
- r4_finish_test_host.dart (48):
- r4_order_completion_test.dart (81):
- r4_order_policy_test.dart (72):
- r4_order_repository_policy_test.dart (87):
- r4_order_store_guards_test.dart (66):
- r4_profile_persistence_test.dart (50):
- r4_setting_controller_test.dart (61):
- r4_settings_operational_section_test.dart (43):
- r4_settings_page_test.dart (86):
- r4_settings_test_support.dart (23): BusinessSaveControl, ControlledBusiness
- receipt_fixtures.dart (86):
- receipt_formatter_settings_test.dart (31):
- receipt_formatter_test.dart (70):
- receipt_page_test.dart (67):
- receipt_preview_test.dart (28):
- receipt_template_lines.dart (28):
- receipt_toggle_list_test.dart (37):
- report_export_test.dart (48): RetryExportService
- report_page_test.dart (69):
- report_states_test.dart (61):
- report_summary_test.dart (36):
- report_view_test.dart (68):
- root_scaffold_test.dart (39):
- savings_row_test.dart (33):
- section_header_test.dart (26):
- service_directory_page_test.dart (110):
- service_picker_list_section_test.dart (38):
- service_picker_test.dart (54):
- service_row_test.dart (41):
- settings_page_test.dart (68):
- sheet_scaffold_test.dart (37):
- stat_tile_test.dart (24):
- stepper_field_test.dart (33):
- sub_scaffold_fab_test.dart (37):
- sub_scaffold_test.dart (32):
- sync_indicator_test.dart (23):
- template_gallery.dart (54):
- toggle_row_test.dart (25):

### test/tool/
- check_arch_test.dart (188):

### test/
- top_services_test.dart (30):
- transaction_customer_section_test.dart (50):
- transaction_draft_test.dart (43):
- transaction_golden_test.dart (118):
- transaction_page_test.dart (119):
- weekly_bar_chart_test.dart (30):
- weight_edit_test.dart (184):
- weight_input_display_test.dart (38):
- widget_test.dart (23):

### tool/
- check_all.dart (37): Step
- check_arch.dart (200): Rule, Registry
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
- app_bottom_sheet_keyboard_use_case.dart (23):
- app_bottom_sheet_use_case.dart (36):
- bottom_nav_bar_use_case.dart (18):
- confirm_modal_use_case.dart (35):
- customer_row_use_case.dart (44):
- expense_row_use_case.dart (27):
- fixture_labels.dart (10):
- nota_card_use_case.dart (51):
- numpad_use_case.dart (23):
- o1.dart (23):
- o2.dart (25):
- order_card_use_case.dart (67):
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
- form_scaffold_use_case.dart (51):
- root_scaffold_use_case.dart (47):
- sheet_scaffold_use_case.dart (59):
- sub_scaffold_use_case.dart (55):
- templates.dart (15):
