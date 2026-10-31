import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/proposals/widgets/proposal_fields_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_history_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_message_section.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('ProposalMessageSection shows source/new badge and open callback', (tester) async {
    var opens = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ProposalMessageSection(
            review: ProposalReview(proposalFixtures.last, null, serviceFixtures),
            onWhatsApp: () => opens++,
          ),
        ),
      ),
    );
    expect(find.text('Belum terdaftar'), findsOneWidget);
    expect(find.textContaining('Halo, saya Agus.'), findsOneWidget);
    await tester.tap(find.text('Buka WhatsApp'));
    expect(opens, 1);
  });
  testWidgets('ProposalFieldsSection delegates name edit and service selection', (tester) async {
    var name = '';
    var service = '';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProposalFieldsSection(
              review: ProposalReview(proposalFixtures.last, null, serviceFixtures),
              draft: const ProposalDraft(
                name: 'Agus Pratama',
                phone: '0856-4400-1234',
                address: '',
                serviceId: 'srv-004',
              ),
              enabled: true,
              onName: (v) => name = v,
              onPhone: (_) {},
              onAddress: (_) {},
              onService: (v) => service = v,
            ),
          ),
        ),
      ),
    );
    final field = find.descendant(
      of: find.byWidgetPredicate((w) => w is AppTextField && w.label == 'Nama pelanggan'),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'Agus Baru');
    expect(name, 'Agus Baru');
    final chip = find.descendant(of: find.byType(ChipBar), matching: find.text('Cuci kiloan'));
    await tester.ensureVisible(chip);
    await tester.tap(chip);
    expect(service, 'srv-002');
  });
  testWidgets('ProposalHistorySection counts baseline and delegates filter', (tester) async {
    var filter = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ProposalHistorySection(
            history: const ProposalHistory([]),
            filter: 0,
            onFilter: (v) => filter = v,
            onOpen: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Disetujui 142'), findsOneWidget);
    expect(find.text('Belum ada rincian usulan'), findsOneWidget);
    await tester.tap(find.text('Menunggu 0'));
    expect(filter, 1);
  });
}
