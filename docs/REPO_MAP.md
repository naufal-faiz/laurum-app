# REPO MAP

Dibuat otomatis oleh `dart run tool/repo_map.dart`. Jangan diedit manual.
Baca berkas ini sebagai pengganti memindai folder.

## Registry widget: 60/60 dibuat

Semua widget sudah dibuat.

## Dependensi

flutter, cupertino_icons, flutter_riverpod, go_router, equatable, intl, ionicons, flutter_svg, flutter_localizations, uuid, drift, sqlite3, path_provider, crypto, supabase_flutter, connectivity_plus, flutter_test, flutter_lints, widgetbook, riverpod_lint, drift_dev, build_runner, fake_async

## Berkas (jumlah baris): nama deklarasi

### lib/
- app.dart (51): LaurumApp

### lib/core/domain/
- business_profile.dart (50): BusinessProfile
- cancellation.dart (77):
- customer.dart (25): Customer
- customer_search.dart (18):
- domain_enums.dart (18): OrderStatus, PayStatus, PayTerm, ServiceKind, PayMethod, SavingsKind, ProposalStatus, OrderSource, RecordSyncState
- domain_record.dart (18): DomainRecord
- expense.dart (36): Expense
- expense_category.dart (19): ExpenseCategory
- id_generator.dart (13): IdGenerator
- money.dart (34):
- order.dart (89): Order
- order_event.dart (37): OrderEvent
- order_item.dart (41): OrderItem
- order_number_generator.dart (53): OrderNumberGenerator
- order_rules.dart (46):
- payment.dart (37): Payment
- payment_corrections.dart (44):
- payment_excess.dart (22):
- proposal.dart (70): Proposal
- receipt_formatter.dart (83):
- receipt_layout.dart (77): ReceiptLayout
- receipt_settings.dart (38): ReceiptSettings
- record_content.dart (13):
- report.dart (71):
- report_daily.dart (16):
- report_positions.dart (37): ReportPositions
- report_range.dart (16): ReportRange
- report_totals.dart (30): ReportTotals

### lib/core/domain/repositories/
- business_repository.dart (8): BusinessRepository
- customer_repository.dart (9): CustomerRepository
- expense_repository.dart (13): ExpenseRepository
- local_settings_repository.dart (6): LocalSettingsRepository
- order_repository.dart (41): OrderRepository
- proposal_repository.dart (13): ProposalRepository
- receipt_settings_repository.dart (6): ReceiptSettingsRepository
- report_repository.dart (10): ReportRepository
- savings_repository.dart (9): SavingsRepository
- service_repository.dart (8): ServiceRepository

### lib/core/domain/
- revenue_allocation.dart (29):
- savings_entry.dart (26): SavingsEntry
- savings_rules.dart (59):
- service_item.dart (38): ServiceItem
- service_revenue.dart (15): ServiceRevenue
- top_services.dart (58):

### lib/core/formatters/
- formatters.dart (55): Formatters

### lib/core/icons/
- app_icons.dart (50): AppIcons
- app_svgs.dart (9): AppSvgs

### lib/core/persistence/
- account_local_data_service.dart (27): AccountLocalDataService
- account_repositories.dart (51): AccountRepositories
- account_storage.dart (88): AccountStorage
- account_store.dart (27): AccountStore
- app_database.dart (54): AppDatabase
- app_database_factory.dart (59): AppDatabaseFactory
- business_records.dart (14): BusinessRecords
- customer_keys_migration.dart (26):
- customer_records.dart (25): CustomerRecords
- demo_fixture_id.dart (5):
- demo_seed_payloads.dart (35):
- demo_seeder.dart (63): DemoSeeder
- device_records.dart (12): DeviceRecords
- drift_change_monitor.dart (22): DriftChangeMonitor
- drift_local_data_service.dart (50): DriftLocalDataService
- drift_local_settings_repository.dart (39): DriftLocalSettingsRepository
- drift_repository_overrides.dart (60):
- drift_sync_ack_writer.dart (50): DriftSyncAckWriter
- drift_sync_cursor_store.dart (38): DriftSyncCursorStore
- drift_sync_outbox_store.dart (99): DriftSyncOutboxStore
- drift_sync_remote_applier.dart (86): DriftSyncRemoteApplier
- drift_sync_service.dart (105): DriftSyncService
- drift_transaction_runner.dart (79): DriftTransactionRunner, _DriftScope
- entitlement_records.dart (16): EntitlementRecords
- expense_category_records.dart (10): ExpenseCategoryRecords
- expense_records.dart (22): ExpenseRecords
- local_setting_records.dart (16): LocalSettingRecords
- order_event_records.dart (16): OrderEventRecords
- order_indexes_migration.dart (25):
- order_item_records.dart (23): OrderItemRecords
- order_records.dart (34): OrderRecords
- outbox_records.dart (28): OutboxRecords
- outbox_writer.dart (59): OutboxWriter
- payment_records.dart (23): PaymentRecords
- receipt_setting_records.dart (20): ReceiptSettingRecords
- record_columns.dart (17): RecordColumns, SoftDeleteColumns
- remote_value_normalizer.dart (31):
- report_indexes_migration.dart (28):
- savings_records.dart (29): SavingsRecords
- schema_migration.dart (12):
- service_records.dart (21): ServiceRecords
- sql_timestamp.dart (6):
- storage_providers.dart (64): storageGateEnabledProvider, accountStorageProvider, activeOwnerProvider, accountStoreProvider, accountChangesProvider
- sync_bindings.dart (41): syncConnectionMonitorProvider, syncBindingsProvider
- sync_cursor_records.dart (12): SyncCursorRecords
- sync_groups_migration.dart (18):
- sync_last_at_store.dart (19): SyncLastAtStore
- sync_outbox_counter.dart (19): SyncOutboxCounter

### lib/core/services/
- auth_failure.dart (8): AuthFailureKind, AuthFailure
- auth_service.dart (23): AuthService
- contact_source.dart (31): ContactItem, ContactSource, ContactPermissionDenied, FakeContactSource
- dummy_history.dart (13): DummyHistory, dummyHistoryEnabledProvider, dummyHistoryProvider
- export_service.dart (19): ExportService, FakeExportService
- external_launcher.dart (25): ExternalLauncher, FakeExternalLauncher
- fake_auth_account.dart (31): FakeAuthAccount
- fake_auth_accounts.dart (102): FakeAuthAccounts
- fake_auth_service.dart (87): FakeAuthService
- fake_password_auth.dart (76): FakePasswordAuth
- fake_sync_service.dart (103): FakeSyncService
- id_generator_provider.dart (4): idGeneratorProvider
- in_memory_local_settings_repository.dart (26): InMemoryLocalSettingsRepository
- in_memory_transaction_runner.dart (55): InMemoryTransactionRunner, _TransactionScope
- local_data_service.dart (18): LocalDataService, FakeLocalDataService
- local_settings_providers.dart (11): localSettingsRepositoryProvider, orderNumberGeneratorProvider
- photo_picker.dart (16): PhotoPicker, FakePhotoPicker
- print_service.dart (96): PrintStatus, PrinterDevice, ReceiptData, PrintService, FakePrintService
- repository_providers.dart (51): businessRepositoryProvider, receiptSettingsRepositoryProvider, customerRepositoryProvider, serviceRepositoryProvider, orderRepositoryProvider, savingsRepositoryProvider, expenseRepositoryProvider, proposalRepositoryProvider, reportRepositoryProvider, transactionRunnerProvider
- service_providers.dart (41): printServiceProvider, externalLauncherProvider, contactSourceProvider, photoPickerProvider, exportServiceProvider, authServiceProvider, localDataServiceProvider, syncServiceProvider
- store_configuration.dart (10):
- sync_service.dart (34): SyncServiceStatus, SyncService
- transaction_runner.dart (8): TransactionRunner, TransactionParticipant
- transactional_memory.dart (10): TransactionalMemory

### lib/core/sync/
- canonical_json.dart (16):
- connection_monitor.dart (20): ConnectionMonitor, NoopConnectionMonitor
- connectivity_connection_monitor.dart (37): ConnectivityConnectionMonitor
- in_memory_outbox_store.dart (104): InMemoryOutboxStore, _Row
- supabase_sync_transport.dart (65): SupabaseSyncTransport
- supabase_sync_wire.dart (77):
- sync_change.dart (25): SyncChange
- sync_coordinator.dart (31): SyncCycleResult, SyncCycle, SyncCoordinator
- sync_cursor_store.dart (6): SyncCursorStore
- sync_engine.dart (108): SyncEngine
- sync_group.dart (7): SyncGroup
- sync_hash.dart (6):
- sync_outbox_store.dart (14): SyncOutboxStore
- sync_pull_cursor.dart (9): SyncCursor
- sync_pull_page.dart (15): SyncPullPage
- sync_pull_request.dart (20): SyncPullRequest
- sync_pull_result.dart (17): SyncPullStatus, SyncPullResult
- sync_pull_runner.dart (53): SyncPullRunner
- sync_pull_transport.dart (6): SyncPullTransport
- sync_push_request.dart (27): SyncPushRequest
- sync_push_result.dart (47): SyncGroupStatus, SyncChangeResult, SyncPushResult
- sync_remote_applier.dart (3): SyncRemoteApplier
- sync_run_result.dart (15): SyncRunStatus, SyncRunResult
- sync_scheduler.dart (108): SyncScheduler
- sync_table_names.dart (34):
- sync_timing.dart (13):
- sync_transport.dart (6): SyncTransport
- sync_transport_exception.dart (7): SyncTransportException
- sync_trigger.dart (73): SyncTrigger

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
- app_theme.dart (53): AppTheme
- receipt_edge_clipper.dart (27): ReceiptEdgeClipper

### lib/features/auth/data/
- auth_fixtures.dart (1):
- dummy_account_data.dart (52):
- dummy_session_overrides.dart (50):
- dummy_transaction_runner.dart (25):
- local_auth_service.dart (18):
- reset_account_drafts.dart (26):

### lib/features/auth/pages/
- account_edit_sheet.dart (33): AccountEditSheet
- account_flow.dart (47):
- auth_routes.dart (36):
- change_password_sheet.dart (52): ChangePasswordSheet
- check_email_page.dart (43): CheckEmailPage
- manage_account_page.dart (53): ManageAccountPage
- password_reset_page.dart (26): PasswordResetPage
- sign_in_page.dart (74): SignInPage
- sign_up_page.dart (58): SignUpPage

### lib/features/auth/state/
- account_edit.dart (52): AccountField, AccountEditView, AccountEdit, accountEditProvider
- account_identity.dart (11): AccountIdentity, accountIdentityProvider
- account_view.dart (16): AccountView
- auth_error.dart (9):
- auth_form.dart (83): AuthForm, authFormProvider
- auth_form_view.dart (34): AuthFormKind, AuthSecret, AuthFormView
- auth_router_refresh.dart (11): authRouterRefreshProvider
- auth_session.dart (92): AuthSession, authSessionProvider
- auth_state.dart (16): AuthState
- auth_validation.dart (45):
- password_reset.dart (64): PasswordReset, passwordResetProvider
- password_reset_view.dart (29): PasswordResetView

### lib/features/auth/widgets/
- account_danger_section.dart (45): AccountDangerSection
- account_edit_field_section.dart (34): AccountEditFieldSection
- account_profile_section.dart (63): AccountProfileSection
- auth_identity_section.dart (55): AuthIdentitySection
- auth_passwords_section.dart (59): AuthPasswordsSection
- auth_secret_field_section.dart (31): AuthSecretFieldSection
- password_reset_section.dart (36): PasswordResetSection
- sign_in_section.dart (33): SignInSection

### lib/features/business/data/
- business_fixtures.dart (21):
- business_storage_mapping.dart (47):
- drift_business_repository.dart (68): DriftBusinessRepository
- in_memory_business_repository.dart (52): BusinessState, InMemoryBusinessRepository, inMemoryBusinessRepositoryProvider

### lib/features/business/pages/
- business_info_page.dart (105): BusinessInfoPage

### lib/features/business/state/
- business_info_controller.dart (79): BusinessInfoController, businessInfoProvider
- business_info_state.dart (40): BusinessInfoState

### lib/features/customers/data/
- contact_fixtures.dart (8):
- customer_fixtures.dart (57):
- customer_history_fixtures.dart (8):
- customer_history_offsets.dart (22):
- customer_queries.dart (39):
- customer_storage_mapping.dart (57):
- drift_customer_repository.dart (84): DriftCustomerRepository
- drift_savings_repository.dart (81): DriftSavingsRepository
- in_memory_customer_repository.dart (91): InMemoryCustomerRepository, inMemoryCustomerRepositoryProvider
- in_memory_savings_repository.dart (59): InMemorySavingsRepository, inMemorySavingsRepositoryProvider
- savings_entry_content.dart (13):
- savings_fixtures.dart (86):
- savings_history.dart (10):
- savings_storage_mapping.dart (45):
- validate_savings_parent.dart (21):

### lib/features/customers/pages/
- customer_deposit_page.dart (71): CustomerDepositPage
- customer_detail_page.dart (56): CustomerDetailPage
- customer_directory_page.dart (69): CustomerDirectoryPage
- customer_edit_sheet.dart (68): CustomerEditSheet
- customer_import_page.dart (67): CustomerImportPage
- customer_savings_history_page.dart (63): CustomerSavingsHistoryPage

### lib/features/customers/state/
- customer_deposit_controller.dart (80): CustomerDepositController, customerDepositProvider
- customer_deposit_state.dart (39): CustomerDepositState
- customer_detail_data.dart (51): CustomerMovement, CustomerDetailData, customerDetailProvider
- customer_directory_controller.dart (20): CustomerDirectoryFilter, CustomerDirectorySearch, customerDirectoryFilterProvider, customerDirectorySearchProvider
- customer_directory_data.dart (81): CustomerDirectoryRow, customerSummariesProvider, customerDirectoryProvider
- customer_edit_controller.dart (90): CustomerEditController, customerEditProvider
- customer_edit_state.dart (36): CustomerEditState
- customer_history_offsets.dart (6): customerHistoryOffsetsProvider
- customer_import_controller.dart (65): CustomerImportState, CustomerImportSelection, customerImportSelectionProvider
- customer_import_data.dart (53): ContactImportRow, ContactImportData, contactImportProvider
- customer_savings_controller.dart (14): CustomerSavingsFilter, customerSavingsFilterProvider
- customer_savings_data.dart (59): CustomerSavingsData, customerSavingsProvider

### lib/features/customers/widgets/
- customer_deposit_form_section.dart (88): CustomerDepositFormSection
- customer_directory_actions_section.dart (51): CustomerDirectoryActionsSection
- customer_directory_list_section.dart (93): CustomerDirectoryListSection
- customer_edit_form_section.dart (65): CustomerEditFormSection
- customer_import_list_section.dart (94): CustomerImportListSection
- customer_orders_section.dart (39): CustomerOrdersSection
- customer_profile_section.dart (75): CustomerProfileSection
- customer_savings_header_section.dart (66): CustomerSavingsHeaderSection
- customer_savings_list_section.dart (58): CustomerSavingsListSection
- customer_savings_section.dart (54): CustomerSavingsSection

### lib/features/expenses/data/
- drift_expense_reader.dart (28): DriftExpenseReader
- drift_expense_repository.dart (91): DriftExpenseRepository
- expense_category_fixtures.dart (35):
- expense_category_storage.dart (35):
- expense_fixtures.dart (10):
- expense_photo_store.dart (35): ExpensePhotoStore
- expense_queries.dart (31):
- expense_storage.dart (62):
- in_memory_expense_repository.dart (98): InMemoryExpenseRepository, inMemoryExpenseRepositoryProvider
- prior_expense_fixtures.dart (72):
- week_expense_fixtures.dart (48):

### lib/features/expenses/pages/
- expense_category_sheet.dart (46): ExpenseCategorySheet
- expense_detail_sheet.dart (71): ExpenseDetailSheet
- expense_directory_page.dart (74): ExpenseDirectoryPage
- expense_form_page.dart (82): ExpenseFormPage

### lib/features/expenses/state/
- expense_category_controller.dart (49): ExpenseCategoryDraft, ExpenseCategoryController, expenseCategoryProvider
- expense_delete_controller.dart (26): ExpenseDeleteController, expenseDeleteProvider
- expense_directory.dart (37): ExpenseDirectory, ExpenseFilter, expenseDirectoryProvider, expenseFilterProvider
- expense_draft.dart (41): ExpenseDraft
- expense_form_controller.dart (75): ExpenseFormController, expenseFormProvider

### lib/features/expenses/widgets/
- expense_amount_section.dart (42): ExpenseAmountSection
- expense_details_section.dart (85): ExpenseDetailsSection
- expense_list_section.dart (97): ExpenseListSection

### lib/features/orders/data/
- active_order_queries.dart (40):
- drift_order_reader.dart (65): DriftOrderReader
- drift_order_repository.dart (67): DriftOrderRepository
- in_memory_order_reader.dart (69): InMemoryOrderReader
- in_memory_order_repository.dart (69): InMemoryOrderRepository, inMemoryOrderRepositoryProvider
- order_event_fixtures.dart (26):
- order_event_storage.dart (54):
- order_fixture_factory.dart (26):
- order_fixtures.dart (8):
- order_history_fixtures.dart (43):
- order_item_fixtures.dart (43):
- order_item_storage.dart (51):
- order_ledger.dart (14):
- order_payment_validation.dart (31):
- order_queue_fixtures.dart (8):
- order_queue_process_fixtures.dart (81):
- order_queue_ready_fixtures.dart (42):
- order_range_queries.dart (74):
- order_snapshot_write.dart (89):
- order_sql_enum.dart (4):
- order_storage_read.dart (25):
- order_storage_write.dart (45):
- order_store.dart (20): OrderStore
- order_store_seed.dart (14):
- order_store_write.dart (93):
- order_write_state.dart (63):
- payment_fixtures.dart (31):
- payment_storage.dart (49):

### lib/features/orders/pages/
- antrean_page.dart (101): AntreanPage
- order_cancel_flow.dart (24):
- order_completion_flow.dart (19):
- order_detail_menu_flow.dart (22):
- order_detail_page.dart (93): OrderDetailPage
- order_edit_page.dart (84): OrderEditPage
- order_menu_sheet.dart (60): OrderMenuAction, OrderMenuSheet
- order_status_sheet.dart (67): OrderStatusSheet
- payment_record_flow.dart (28):
- payment_record_sheet.dart (71): PaymentRecordSheet

### lib/features/orders/state/
- antrean_controller.dart (91): AntreanFilter, AntreanActionState, AntreanActions, antreanFilterProvider, antreanActionsProvider
- antrean_data.dart (65): AntreanData, antreanDataProvider
- antrean_filter_view.dart (9): AntreanFilterView
- order_completion_controller.dart (47): OrderCompletionState, OrderCompletion, orderCompletionProvider
- order_completion_save.dart (54):
- order_detail_controller.dart (97): OrderActionState, OrderActions, orderActionsProvider
- order_detail_data.dart (98): ActivityEntry, OrderDetailData, orderDetailProvider
- order_edit_controller.dart (102): OrderEditState, OrderEdit, orderEditProvider
- order_edit_item.dart (27):
- order_edit_order.dart (22):
- order_payment_controller.dart (56): OrderPaymentState, OrderPaymentAction, orderPaymentProvider
- order_payment_save.dart (95):
- payment_draft.dart (41): PaymentDraftState, PaymentDraft, paymentDraftProvider
- payment_label.dart (10):

### lib/features/orders/widgets/
- antrean_orders_section.dart (54): AntreanOrdersSection
- antrean_status_section.dart (74): AntreanStatusSection
- order_customer_section.dart (56): OrderCustomerSection
- order_detail_body_section.dart (35): OrderDetailBodySection
- order_detail_content_section.dart (70): OrderDetailContentSection
- order_detail_footer_section.dart (99): OrderDetailFooterSection
- order_edit_body_section.dart (61): OrderEditBodySection
- order_edit_customer_section.dart (43): OrderEditCustomerSection
- order_items_section.dart (76): OrderItemsSection
- order_payment_section.dart (44): OrderPaymentSection
- order_summary_section.dart (56): OrderSummarySection
- order_timeline_section.dart (55): OrderTimelineSection
- payment_record_input_section.dart (58): PaymentRecordInputSection

### lib/features/printer/data/
- drift_receipt_settings_repository.dart (54): DriftReceiptSettingsRepository
- in_memory_receipt_settings_repository.dart (14): InMemoryReceiptSettingsRepository
- receipt_demo.dart (74):
- receipt_storage_mapping.dart (47):

### lib/features/printer/pages/
- bluetooth_sheet.dart (44): BluetoothSheet
- printer_device_sheet.dart (49): PrinterDeviceSheet
- printer_page.dart (84): PrinterPage

### lib/features/printer/state/
- printer_connection.dart (93): PrinterConnectionController, printerConnectionProvider
- printer_settings.dart (91): PrinterSettingsState, PrinterSettingsController, printerSettingsProvider
- printer_state.dart (78): PrinterConnectionState
- save_printer_settings.dart (25):

### lib/features/printer/widgets/
- printer_connection_section.dart (79): PrinterConnectionSection
- printer_preview_section.dart (42): PrinterPreviewSection
- printer_settings_section.dart (84): PrinterSettingsSection

### lib/features/proposals/data/
- account_proposal_fixtures.dart (23):
- in_memory_proposal_repository.dart (58): InMemoryProposalRepository, proposalSeedProvider, inMemoryProposalRepositoryProvider
- proposal_fixtures.dart (47):

### lib/features/proposals/pages/
- ai_routes.dart (15):
- ai_settings_page.dart (85): AiSettingsPage
- proposal_detail_page.dart (99): ProposalDetailPage
- proposal_history_page.dart (47): ProposalHistoryPage
- proposal_review_flow.dart (68):
- whatsapp_link_page.dart (30): WhatsappLinkPage

### lib/features/proposals/state/
- ai_settings.dart (25): AiPreferences, AiSettings, aiSettingsProvider
- proposal_accept.dart (62):
- proposal_actions.dart (73): ProposalActions, proposalActionsProvider
- proposal_history.dart (46): ProposalHistory, ProposalHistoryFilter, proposalHistoryProvider, proposalHistoryFilterProvider
- proposal_order.dart (68):
- proposal_review.dart (92): ProposalReview, ProposalDraft, ProposalDraftController, proposalReviewProvider, proposalDraftProvider
- whatsapp_link.dart (38): WhatsappLinkStatus, WhatsappLink, whatsappLinkProvider

### lib/features/proposals/widgets/
- ai_connection_section.dart (59): AiConnectionSection
- ai_preferences_section.dart (64): AiPreferencesSection
- proposal_fields_section.dart (95): ProposalFieldsSection
- proposal_history_section.dart (49): ProposalHistorySection
- proposal_message_section.dart (44): ProposalMessageSection
- whatsapp_link_section.dart (75): WhatsappLinkSection

### lib/features/reports/data/
- drift_report_repository.dart (42): DriftReportRepository
- in_memory_report_repository.dart (62): InMemoryReportRepository, inMemoryReportRepositoryProvider
- report_positions_sql.dart (35):
- report_range_queries.dart (63):
- report_ranges.dart (6):
- report_repository_view.dart (18): ReportRepositoryView
- report_samples.dart (31):

### lib/features/reports/pages/
- outstanding_page.dart (73): OutstandingPage
- report_page.dart (105): ReportPage
- report_range_flow.dart (41):

### lib/features/reports/state/
- outstanding_data.dart (69): OutstandingRow, OutstandingListData, OutstandingFilter, outstandingListProvider, outstandingFilterProvider
- report_custom_range.dart (24): ReportCustomRange, reportCustomRangeProvider
- report_daily_view.dart (10):
- report_export.dart (97): ReportExportState, ReportExport, reportExportProvider
- report_orders_controller.dart (24): ReportOrdersFilter, ReportOrdersSearch, reportOrdersFilterProvider, reportOrdersSearchProvider
- report_orders_data.dart (68): ReportOrdersData, reportOrdersProvider
- report_period.dart (30): ReportPeriod, reportPeriodProvider
- report_view.dart (77): ReportView, reportViewProvider

### lib/features/reports/widgets/
- outstanding_list_section.dart (76): OutstandingListSection
- report_body_section.dart (99): ReportBodySection
- report_orders_section.dart (104): ReportOrdersSection

### lib/features/services/data/
- drift_service_repository.dart (63): DriftServiceRepository
- in_memory_service_repository.dart (80): InMemoryServiceRepository, inMemoryServiceRepositoryProvider
- service_fixtures.dart (67):
- service_storage_mapping.dart (58):

### lib/features/services/pages/
- service_directory_page.dart (71): ServiceDirectoryPage
- service_edit_page.dart (73): ServiceEditPage

### lib/features/services/state/
- service_copy.dart (25):
- service_directory_data.dart (15):
- service_directory_providers.dart (17): ServiceDirectorySearch, serviceDirectoryProvider, serviceDirectorySearchProvider
- service_edit_controller.dart (103): ServiceEditController, serviceEditProvider
- service_edit_state.dart (55): ServiceEditState

### lib/features/services/widgets/
- service_directory_content_section.dart (68): ServiceDirectoryContentSection
- service_directory_list_section.dart (37): ServiceDirectoryListSection
- service_edit_fields_section.dart (100): ServiceEditFieldsSection

### lib/features/settings/pages/
- settings_page.dart (33): SettingsPage

### lib/features/settings/state/
- order_status_setting.dart (31): OrderStatusSettingState, OrderStatusSetting, orderStatusSettingProvider

### lib/features/settings/widgets/
- settings_account_section.dart (53): SettingsAccountSection
- settings_menu_section.dart (82): SettingsMenuSection
- settings_operational_section.dart (59): SettingsOperationalSection

### lib/features/shell/pages/
- app_router.dart (103):
- lainnya_routes.dart (20):
- placeholder_page.dart (31): PlaceholderPage
- placeholder_routes.dart (8):
- root_shell_page.dart (58): RootShellPage

### lib/features/shell/state/
- shell_state.dart (27): FakeWhatsappConnection, businessClockProvider, businessProfileProvider, shellSyncProvider, shellSyncStatusProvider, whatsappConnectionProvider

### lib/features/sync/data/
- sync_fixtures.dart (3):

### lib/features/sync/pages/
- sync_page.dart (33): SyncPage

### lib/features/sync/state/
- sync_view.dart (45): SyncView, SyncActions, syncViewProvider, syncActionsProvider

### lib/features/sync/widgets/
- sync_status_section.dart (61): SyncStatusSection

### lib/features/transactions/pages/
- add_customer_sheet.dart (51): AddCustomerSheet
- cash_input_sheet.dart (57): CashInputSheet
- contact_picker_sheet.dart (58): ContactPickerSheet, contactsProvider
- customer_picker_sheet.dart (97): CustomerPickerSheet
- discount_sheet.dart (74): DiscountSheet
- payment_flow.dart (19):
- payment_page.dart (90): PaymentPage
- receipt_page.dart (89): ReceiptPage
- service_picker_page.dart (54): ServicePickerPage
- transaction_leave_flow.dart (22):
- transaction_line_sheet.dart (76): TransactionLineSheet
- transaction_page.dart (87): TransactionPage
- transaction_routes.dart (37):
- weight_input_sheet.dart (91): WeightInputSheet

### lib/features/transactions/state/
- add_customer_form.dart (102): AddCustomerState, AddCustomerForm, addCustomerFormProvider
- cash_input.dart (37): CashInput, cashInputProvider
- checkout_data.dart (35): CheckoutState
- checkout_item.dart (48):
- checkout_notice.dart (20): CheckoutNotice, checkoutNoticeProvider
- checkout_save.dart (97):
- checkout_state.dart (36): Checkout, checkoutControllerProvider
- discount_input.dart (19): DiscountInputState, DiscountInput, discountInputProvider
- payment_quote.dart (40): PaymentQuote
- receipt_print_controller.dart (59): ReceiptPrintState, ReceiptPrint, receiptPrintProvider
- receipt_view.dart (60): ReceiptView, receiptViewProvider
- transaction_draft.dart (110): DraftLine, TransactionDraftState, TransactionDraft, transactionDraftProvider
- transaction_providers.dart (32): ServiceSearch, CustomerSearch, serviceCatalogProvider, customerCatalogProvider, customerBalanceProvider, serviceSearchProvider, customerSearchProvider
- weight_edit.dart (79): WeightEditState, WeightEdit, weightEditProvider

### lib/features/transactions/widgets/
- add_customer_form_section.dart (77): AddCustomerFormSection
- payment_method_section.dart (72): PaymentMethodSection
- payment_savings_section.dart (55): PaymentSavingsSection
- payment_summary_section.dart (56): PaymentSummarySection
- receipt_actions_section.dart (81): ReceiptActionsSection
- receipt_status_section.dart (96): ReceiptStatusSection
- service_picker_list_section.dart (84): ServicePickerListSection
- transaction_customer_section.dart (57): TransactionCustomerSection
- transaction_details_section.dart (66): TransactionDetailsSection

### lib/
- main.dart (26):
- main_dummy.dart (101):

### lib/shared/widgets/atoms/
- app_avatar.dart (36): AppAvatar
- app_badge.dart (31): AppBadgeVariant, AppBadge
- app_button.dart (65): AppButton
- app_card.dart (47): AppCardRail, AppCard
- app_chip.dart (40): AppChip
- app_divider.dart (16): AppDivider
- app_gap.dart (19): AppGap
- app_icon.dart (27): AppIcon
- app_icon_button.dart (46): AppIconButton
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
- bottom_nav_bar.dart (110): BottomNavBar
- confirm_modal.dart (89): ConfirmModal
- customer_row.dart (102): CustomerRow
- expense_row.dart (57): ExpenseRow
- nota_card.dart (75): NotaCard
- numpad.dart (62): NumpadVariant, Numpad
- order_card.dart (100): OrderCard
- piutang_card.dart (83): PiutangCard
- proposal_card.dart (63): ProposalCard
- receipt_preview.dart (44): ReceiptPreview
- receipt_toggle_list.dart (65): ReceiptToggleList
- report_summary.dart (109): ReportSummary
- savings_row.dart (74): SavingsRow
- service_row.dart (84): ServiceRow
- top_services.dart (106): TopServices
- weekly_bar_chart.dart (110): WeeklyBarChart

### lib/shared/widgets/templates/
- auth_scaffold.dart (20): AuthScaffold
- form_scaffold.dart (44): FormScaffold
- root_scaffold.dart (66): RootScaffold
- sheet_scaffold.dart (40): SheetScaffold
- sub_scaffold.dart (62): SubScaffold

### test/
- account_actions_test.dart (60):
- account_rollback_test.dart (56): FailingClearSync
- add_customer_test.dart (64):
- ai_golden_test.dart (52):
- ai_sections_test.dart (82):
- ai_settings_pages_test.dart (52):
- ai_settings_state_test.dart (41):
- antrean_controller_test.dart (67):
- antrean_golden_test.dart (52):
- antrean_page_test.dart (61):
- antrean_states_test.dart (82):
- antrean_test_host.dart (50):
- antrean_test_host_test.dart (22):
- app_avatar_test.dart (28):
- app_badge_test.dart (29):
- app_bar_root_test.dart (32):
- app_bar_sub_test.dart (26):
- app_bottom_sheet_test.dart (45):
- app_button_test.dart (71):
- app_card_test.dart (51):
- app_chip_test.dart (41):
- app_divider_test.dart (41):
- app_gap_test.dart (33):
- app_icon_button_test.dart (51):
- app_icon_test.dart (29):
- app_numpad_key_test.dart (43):
- app_router_test.dart (64):
- app_search_field_test.dart (66):
- app_skeleton_test.dart (32):
- app_status_text_test.dart (26):
- app_svg_test.dart (45): SvgTestBundle
- app_switch_test.dart (42):
- app_text_field_focus_test.dart (53):
- app_text_field_test.dart (70):
- app_text_test.dart (39):
- atom_gallery_test.dart (75):
- auth_onboarding_keyboard_test.dart (33):
- auth_restore_test.dart (45): DeferredRestore
- auth_routes_test.dart (60):
- auth_scaffold_test.dart (22):
- auth_session_test.dart (64):
- auth_sync_golden_test.dart (84):
- auth_sync_sections_test.dart (93):
- banner_message_test.dart (23):
- bottom_nav_bar_test.dart (104):
- bp0_id_flow_test.dart (61):
- business_info_page_test.dart (50):
- callout_ai_test.dart (20):
- checkout_controller_test.dart (90):
- chip_bar_test.dart (30):
- confirm_modal_test.dart (74):

### test/contracts/
- business_contract.dart (44):
- business_values.dart (43):
- customer_contract.dart (51):
- customer_query_contract.dart (49):
- expense_contract.dart (66):
- expense_values.dart (17):
- local_settings_contract.dart (27):
- order_contract.dart (78):
- order_extra_contract.dart (66):
- order_item_contract.dart (28):
- order_payment_contract.dart (44):
- order_values.dart (62):
- receipt_settings_contract.dart (41):
- record_values.dart (28):
- report_contract.dart (98): ReportContractContext, ReportContractFactory
- report_mutation_contract.dart (51):
- repository_factory.dart (3): RepositoryFactory
- savings_contract.dart (43):
- savings_extra_contract.dart (43):
- service_contract.dart (61):
- transaction_runner_contract.dart (60): RunnerHarness

### test/
- contracts_in_memory_test.dart (62):
- contracts_runner_test.dart (21):
- customer_deposit_page_test.dart (50):
- customer_detail_data_test.dart (61):
- customer_detail_page_test.dart (86):
- customer_detail_states_test.dart (60):
- customer_directory_actions_section_test.dart (41):
- customer_directory_data_test.dart (39):
- customer_directory_states_test.dart (64):
- customer_directory_test.dart (100):
- customer_import_page_test.dart (68):
- customer_row_test.dart (39):
- customer_savings_section_test.dart (48):
- date_group_header_test.dart (24):
- discount_input_test.dart (118):
- domain_cancel_test.dart (74):
- domain_flow_test.dart (51):
- domain_models_1_test.dart (38):
- domain_models_2_test.dart (42):
- domain_models_3_test.dart (28):
- domain_money_test.dart (48):
- domain_order_models_test.dart (30):
- domain_report_test.dart (74):
- domain_samples.dart (89):
- domain_savings_test.dart (87):
- domain_schedule_test.dart (35):
- domain_top_services_test.dart (34):
- drift_app_harness.dart (57):
- drift_app_test.dart (65):
- drift_empty_test.dart (35):
- drift_payment_flow_test.dart (94):
- drift_widget_step.dart (10):
- dummy_cancellation_ledger_test.dart (35):
- dummy_catalog_integration_test.dart (56):
- dummy_data_integration_test.dart (64):
- dummy_fixture_integrity_test.dart (51):
- dummy_live_creation_test.dart (59):
- dummy_order_atomicity_test.dart (77):
- dummy_provider_notifications_test.dart (71):
- dummy_report_ledger_test.dart (39):
- dummy_report_mutation_test.dart (56):
- dummy_repository_regression_test.dart (52):
- dummy_savings_integration_test.dart (49):
- empty_state_test.dart (28):
- expense_controller_test.dart (78):
- expense_failures_test.dart (76): FailingExpenseRepository
- expense_form_actions_test.dart (49):
- expense_golden_test.dart (38):
- expense_keyboard_test.dart (70):
- expense_pages_test.dart (66):
- expense_row_test.dart (34):
- expense_sections_test.dart (87):
- fake_id_generator.dart (20): FakeIdGenerator
- footer_bar_test.dart (30):
- form_scaffold_test.dart (33):
- formatters_test.dart (40):
- id_generator_test.dart (39):
- info_row_test.dart (25):
- input_templates_keyboard_test.dart (72):
- keyboard_audit_test.dart (150):
- keyboard_test_helper.dart (52):
- labeled_field_test.dart (29):
- local_auth_service_test.dart (18):
- local_settings_test.dart (35):
- locked_row_test.dart (25):
- menu_row_test.dart (25):
- molecule_gallery.dart (35):
- nominal_chips_test.dart (25):
- nominal_input_test.dart (77):
- nota_card_test.dart (37):
- notice_ai_test.dart (20):
- numpad_test.dart (47):
- order_actions_test.dart (72):
- order_card_test.dart (89):
- order_detail_receipt_test.dart (80):
- order_detail_test.dart (89):
- order_edit_test.dart (80):
- order_number_generator_test.dart (34):
- organism_gallery.dart (54):
- outstanding_page_test.dart (38):
- payment_golden_test.dart (60):
- payment_page_test.dart (59):
- period_tabs_test.dart (29):

### test/persistence/
- account_storage_test.dart (54):
- b1c_harness.dart (31): B1cHarness
- b1d_commands.dart (44):
- b1d_harness.dart (89): B1dHarness
- b1d_overrides.dart (39):
- business_service_atomic_test.dart (73):
- business_service_contracts_test.dart (53):
- business_service_reopen_test.dart (46):
- business_service_scope_test.dart (59):
- customer_keys_migration_test.dart (69):
- customer_query_plan_test.dart (20):
- customer_savings_atomic_test.dart (98):
- customer_savings_contracts_test.dart (33):
- customer_summary_ledger_test.dart (44):
- database_factory_test.dart (51):
- database_migration_test.dart (56):
- database_schema_test.dart (73):
- date_time_storage_test.dart (29):
- demo_seed_atomic_test.dart (45):
- demo_seeder_test.dart (50):
- drift_contracts_test.dart (30):
- drift_runner_test.dart (55):
- drift_sync_close_test.dart (22):
- drift_sync_cursor_store_test.dart (44):
- drift_sync_outbox_store_test.dart (123):
- drift_sync_remote_applier_test.dart (120):
- drift_sync_service_test.dart (127): _Cycle
- expense_atomic_test.dart (89):
- expense_contracts_test.dart (20):
- expense_photos_test.dart (82):
- failing_b1d_proposal.dart (15): FailingB1dProposal

### test/persistence/generated/
- schema.dart (34): GeneratedHelper
- schema_v1.dart (8453): Businesses, BusinessesData, BusinessesCompanion, Devices, DevicesData, DevicesCompanion, Customers, CustomersData, CustomersCompanion, Services, ServicesData, ServicesCompanion, Orders, OrdersData, OrdersCompanion, OrderItems, OrderItemsData, OrderItemsCompanion, Payments, PaymentsData, PaymentsCompanion, SavingsEntries, SavingsEntriesData, SavingsEntriesCompanion, ExpenseCategories, ExpenseCategoriesData, ExpenseCategoriesCompanion, Expenses, ExpensesData, ExpensesCompanion, ReceiptSettings, ReceiptSettingsData, ReceiptSettingsCompanion, Entitlements, EntitlementsData, EntitlementsCompanion, OrderEvents, OrderEventsData, OrderEventsCompanion, Outbox, OutboxData, OutboxCompanion, LocalSettings, LocalSettingsData, LocalSettingsCompanion, SyncCursors, SyncCursorsData, SyncCursorsCompanion, DatabaseAtV1
- schema_v2.dart (8547): Businesses, BusinessesData, BusinessesCompanion, Devices, DevicesData, DevicesCompanion, Customers, CustomersData, CustomersCompanion, Services, ServicesData, ServicesCompanion, Orders, OrdersData, OrdersCompanion, OrderItems, OrderItemsData, OrderItemsCompanion, Payments, PaymentsData, PaymentsCompanion, SavingsEntries, SavingsEntriesData, SavingsEntriesCompanion, ExpenseCategories, ExpenseCategoriesData, ExpenseCategoriesCompanion, Expenses, ExpensesData, ExpensesCompanion, ReceiptSettings, ReceiptSettingsData, ReceiptSettingsCompanion, Entitlements, EntitlementsData, EntitlementsCompanion, OrderEvents, OrderEventsData, OrderEventsCompanion, Outbox, OutboxData, OutboxCompanion, LocalSettings, LocalSettingsData, LocalSettingsCompanion, SyncCursors, SyncCursorsData, SyncCursorsCompanion, DatabaseAtV2
- schema_v3.dart (8562): Businesses, BusinessesData, BusinessesCompanion, Devices, DevicesData, DevicesCompanion, Customers, CustomersData, CustomersCompanion, Services, ServicesData, ServicesCompanion, Orders, OrdersData, OrdersCompanion, OrderItems, OrderItemsData, OrderItemsCompanion, Payments, PaymentsData, PaymentsCompanion, SavingsEntries, SavingsEntriesData, SavingsEntriesCompanion, ExpenseCategories, ExpenseCategoriesData, ExpenseCategoriesCompanion, Expenses, ExpensesData, ExpensesCompanion, ReceiptSettings, ReceiptSettingsData, ReceiptSettingsCompanion, Entitlements, EntitlementsData, EntitlementsCompanion, OrderEvents, OrderEventsData, OrderEventsCompanion, Outbox, OutboxData, OutboxCompanion, LocalSettings, LocalSettingsData, LocalSettingsCompanion, SyncCursors, SyncCursorsData, SyncCursorsCompanion, DatabaseAtV3
- schema_v4.dart (8611): Businesses, BusinessesData, BusinessesCompanion, Devices, DevicesData, DevicesCompanion, Customers, CustomersData, CustomersCompanion, Services, ServicesData, ServicesCompanion, Orders, OrdersData, OrdersCompanion, OrderItems, OrderItemsData, OrderItemsCompanion, Payments, PaymentsData, PaymentsCompanion, SavingsEntries, SavingsEntriesData, SavingsEntriesCompanion, ExpenseCategories, ExpenseCategoriesData, ExpenseCategoriesCompanion, Expenses, ExpensesData, ExpensesCompanion, ReceiptSettings, ReceiptSettingsData, ReceiptSettingsCompanion, Entitlements, EntitlementsData, EntitlementsCompanion, OrderEvents, OrderEventsData, OrderEventsCompanion, Outbox, OutboxData, OutboxCompanion, LocalSettings, LocalSettingsData, LocalSettingsCompanion, SyncCursors, SyncCursorsData, SyncCursorsCompanion, DatabaseAtV4
- schema_v5.dart (8778): Businesses, BusinessesData, BusinessesCompanion, Devices, DevicesData, DevicesCompanion, Customers, CustomersData, CustomersCompanion, Services, ServicesData, ServicesCompanion, Orders, OrdersData, OrdersCompanion, OrderItems, OrderItemsData, OrderItemsCompanion, Payments, PaymentsData, PaymentsCompanion, SavingsEntries, SavingsEntriesData, SavingsEntriesCompanion, ExpenseCategories, ExpenseCategoriesData, ExpenseCategoriesCompanion, Expenses, ExpensesData, ExpensesCompanion, ReceiptSettings, ReceiptSettingsData, ReceiptSettingsCompanion, Entitlements, EntitlementsData, EntitlementsCompanion, OrderEvents, OrderEventsData, OrderEventsCompanion, Outbox, OutboxData, OutboxCompanion, LocalSettings, LocalSettingsData, LocalSettingsCompanion, SyncCursors, SyncCursorsData, SyncCursorsCompanion, DatabaseAtV5

### test/persistence/
- order_account_cleanup_test.dart (39):
- order_checkout_atomic_test.dart (60):
- order_completion_atomic_test.dart (25):
- order_contracts_test.dart (28):
- order_edit_cancel_flow_test.dart (62):
- order_payment_flow_test.dart (48):
- order_proposal_flow_test.dart (66):
- order_query_plan_test.dart (39):
- order_storage_scope_test.dart (93):
- order_time_migration_test.dart (47):
- outbox_group_operation_test.dart (43):
- outbox_writer_test.dart (97):
- printer_repository_integration_test.dart (75):
- report_contracts_test.dart (30):
- report_migration_test.dart (42):
- report_scope_plan_test.dart (45):
- report_seed.dart (45):
- storage_providers_test.dart (85):
- sync_wire_rows.dart (185):

### test/
- piutang_card_test.dart (43):
- platform_services_test.dart (83):
- printer_page_test.dart (100):
- printer_service_test.dart (42):
- progress_row_test.dart (23):
- proposal_actions_test.dart (72):
- proposal_card_test.dart (41):
- proposal_golden_test.dart (35):
- proposal_history_page_test.dart (61):
- proposal_keyboard_test.dart (32):
- proposal_order_rollback_test.dart (54): FailingProposalOrder
- proposal_pages_test.dart (89):
- proposal_retry_test.dart (60): FailOnceProposalRepository
- proposal_sections_test.dart (92):
- r10_account_flow_test.dart (64):
- r10_account_keyboard_test.dart (32):
- r10_account_sections_test.dart (64):
- r10_auth_form_test.dart (51): FailingPasswordAuth
- r10_auth_keyboard_test.dart (34):
- r10_auth_service_test.dart (83):
- r10_auth_validation_test.dart (32):
- r10_form_sections_test.dart (85):
- r10_onboarding_cleanup_test.dart (35):
- r10_registration_flow_test.dart (55):
- r10_reset_state_test.dart (31):
- r10_signin_reset_flow_test.dart (55):
- r10_signup_validation_test.dart (35):
- r10_test_host.dart (65):
- r10_visual_test.dart (70):
- r2_navigation_test.dart (56):
- r3_customer_creation_test.dart (55):
- r3_service_creation_test.dart (50):
- r3_service_picker_keyboard_test.dart (36):
- r4_antrean_action_test.dart (26):
- r4_antrean_filter_test.dart (30):
- r4_antrean_flow_test.dart (72):
- r4_antrean_orders_section_test.dart (60):
- r4_antrean_page_test.dart (70):
- r4_business_profile_test.dart (57):
- r4_completion_guards_test.dart (72):
- r4_completion_test_host.dart (38): CompletionPrinter
- r4_detail_completion_test.dart (95):
- r4_detail_print_failure_test.dart (40):
- r4_finish_flow_test.dart (84):
- r4_finish_test_host.dart (48):
- r4_order_completion_test.dart (80):
- r4_order_policy_test.dart (72):
- r4_order_repository_policy_test.dart (87):
- r4_order_store_guards_test.dart (66):
- r4_profile_persistence_test.dart (50):
- r4_setting_controller_test.dart (61):
- r4_settings_operational_section_test.dart (43):
- r4_settings_page_test.dart (86):
- r4_settings_test_support.dart (23): BusinessSaveControl, ControlledBusiness
- r5_custom_report_test.dart (65):
- r5_picker_test.dart (66):
- r5_range_test.dart (39):
- r5_report_body_section_test.dart (58):
- r5_report_visual_test.dart (70):
- r5_report_widgets_test.dart (100): HeldReportExport
- r9_cards_test.dart (60):
- r9_checkout_flow_test.dart (79):
- r9_checkout_host.dart (37):
- r9_checkout_state_test.dart (52):
- r9_completion_guards_test.dart (25):
- r9_input_test.dart (32):
- r9_order_fixture.dart (22):
- r9_payment_entrypoints_test.dart (44):
- r9_payment_keyboard_test.dart (60):
- r9_payment_rollback_test.dart (68): FailingExcessSavings
- r9_payment_rules_test.dart (83):
- r9_payment_sections_test.dart (93):
- r9_payment_state_test.dart (84):
- r9_payment_visual_test.dart (60):
- r9_receipt_sections_test.dart (84):
- r9_section_host.dart (10):
- r9_validation_flow_test.dart (39):
- raised_navigation_test.dart (52):
- receipt_actions_layout_test.dart (74):
- receipt_cod_visual_test.dart (36):
- receipt_fixtures.dart (86):
- receipt_formatter_settings_test.dart (31):
- receipt_formatter_test.dart (70):
- receipt_page_test.dart (73):
- receipt_preview_test.dart (32):
- receipt_template_lines.dart (28):
- receipt_toggle_list_test.dart (37):
- report_export_test.dart (60): RetryExportService
- report_memory_contract_test.dart (32):
- report_orders_test.dart (108):
- report_page_test.dart (76):
- report_states_test.dart (61):
- report_summary_test.dart (36):
- report_view_test.dart (81):
- root_scaffold_test.dart (39):
- root_scroll_clearance_test.dart (44):
- savings_row_test.dart (33):
- section_header_test.dart (26):
- service_directory_page_test.dart (110):
- service_picker_list_section_test.dart (38):
- service_picker_test.dart (54):
- service_row_test.dart (41):
- settings_page_test.dart (82):
- sheet_scaffold_test.dart (37):
- stat_tile_test.dart (24):
- stepper_field_test.dart (33):
- storage_gate_test.dart (58):
- store_configuration_test.dart (11):
- sub_scaffold_fab_test.dart (37):
- sub_scaffold_test.dart (32):

### test/sync/
- canonical_json_test.dart (35):
- fake_sync_transport.dart (62): FakeSyncTransport
- in_memory_outbox_store_test.dart (13):
- supabase_sync_local_test.dart (281):
- sync_bindings_test.dart (59): _FakeMonitor
- sync_coordinator_test.dart (81): _RecordingPullTransport, _MemoryCursors, _NoopApplier
- sync_engine_test.dart (93):
- sync_pull_runner_test.dart (122): _MemoryCursors, _RecordingApplier, _FakePullTransport, _FailingPullTransport
- sync_pull_wire_test.dart (100):
- sync_scheduler_test.dart (136):
- sync_store_contract.dart (93):

### test/
- sync_changes_test.dart (25):
- sync_indicator_test.dart (23):
- sync_page_test.dart (68):
- template_gallery.dart (54):
- toggle_row_test.dart (25):

### test/tool/
- backend_rules_test.dart (62):
- check_arch_test.dart (188):

### test/
- top_services_test.dart (30):
- transaction_customer_section_test.dart (50):
- transaction_draft_test.dart (43):
- transaction_flow_rollback_test.dart (85): FailingSavings
- transaction_golden_test.dart (70):
- transaction_page_test.dart (136):
- transaction_runner_test.dart (91): TransactionValue
- ui_final_accessibility_test.dart (52):
- ui_final_flow_host.dart (53):
- ui_final_flow_test.dart (83):
- ui_final_routes.dart (36):
- ui_final_sync_test.dart (33):
- weekly_bar_chart_test.dart (30):
- weight_edit_test.dart (184):
- weight_input_display_test.dart (38):
- widget_test.dart (23):

### tool/
- backend_rules.dart (52):
- benchmark_device.dart (83):
- benchmark_orders.dart (89):
- benchmark_reports.dart (53):
- check_all.dart (37): Step
- check_arch.dart (202): Rule, Registry
- pen_frame.dart (42):
- repo_map.dart (100):
- report_benchmark_seed.dart (86):

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
- nota_card_use_case.dart (54):
- numpad_use_case.dart (23):
- o1.dart (23):
- o2.dart (25):
- order_card_use_case.dart (68):
- piutang_card_use_case.dart (40):
- proposal_card_use_case.dart (33):
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
