import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/printer/pages/printer_state.dart';

class PrinterSettingsState {
  const PrinterSettingsState({
    required this.settings,
    required this.profile,
    this.notice,
  });
  final ReceiptSettings settings;
  final BusinessProfile profile;
  final String? notice;
  PrinterSettingsState copyWith({
    ReceiptSettings? settings,
    BusinessProfile? profile,
    String? notice,
    bool clearNotice = false,
  }) => PrinterSettingsState(
    settings: settings ?? this.settings,
    profile: profile ?? this.profile,
    notice: clearNotice ? null : notice ?? this.notice,
  );
}

final printerSettingsProvider =
    AsyncNotifierProvider<PrinterSettingsController, PrinterSettingsState>(
      PrinterSettingsController.new,
    );

class PrinterSettingsController extends AsyncNotifier<PrinterSettingsState> {
  @override
  Future<PrinterSettingsState> build() async {
    final repository = ref.watch(businessRepositoryProvider);
    return PrinterSettingsState(
      settings: await repository.getReceiptSettings(),
      profile: await repository.getProfile(),
    );
  }

  void _set(PrinterSettingsState Function(PrinterSettingsState current) change) {
    final current = state.value;
    if (current != null) state = AsyncData(change(current));
  }

  void edit({
    int? paperMm,
    int? fontSize,
    bool? showAddress,
    bool? showCustomer,
    bool? showSavings,
    bool? showNote,
    String? footer,
    String? note,
  }) => _set(
    (s) => s.copyWith(
      settings: copySettings(
        s.settings,
        paperMm: paperMm,
        fontSize: fontSize,
        showAddress: showAddress,
        showCustomer: showCustomer,
        showSavings: showSavings,
        showNote: showNote,
      ),
      profile: copyProfile(
        s.profile,
        receiptFooter: footer,
        receiptNote: note,
      ),
      clearNotice: true,
    ),
  );

  Future<void> save() async {
    final current = state.value;
    if (current == null) return;
    final repository = ref.read(businessRepositoryProvider);
    await repository.saveReceiptSettings(current.settings);
    await repository.saveProfile(current.profile);
    _set((s) => s.copyWith(notice: 'Pengaturan struk disimpan.'));
  }
}
