import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/proposals/widgets/proposal_address_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_customer_fields_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_privacy_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_service_card_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_service_section.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/notice_ai.dart';

void main() {
  final proposal = proposalFixtures.last;
  final draft = ProposalDraft(
    name: proposal.customerName,
    phone: proposal.phone,
    address: proposal.address,
    serviceId: proposal.serviceId,
  );
  testWidgets('customer fields preserve validation and phone callback', (tester) async {
    var phone = '';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProposalCustomerFieldsSection(
              draft: draft.copyWith(name: '', phone: '123'),
              enabled: true,
              onName: (_) {},
              onPhone: (v) => phone = v,
            ),
          ),
        ),
      ),
    );
    expect(find.text('Nama pelanggan wajib diisi.'), findsOneWidget);
    expect(find.text('Nomor WhatsApp tidak valid.'), findsOneWidget);
    final field = find.descendant(
      of: find.byWidgetPredicate((w) => w is AppTextField && w.label == 'Nomor WhatsApp'),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, draft.phone);
    expect(phone, draft.phone);
    expect(
      tester.widgetList<AppTextField>(find.byType(AppTextField)).every((w) => w.selectAllOnFocus),
      isTrue,
    );
  });
  testWidgets('address preserves uncertainty warning and edit callback', (tester) async {
    var address = '';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ProposalAddressSection(
            draft: draft,
            enabled: true,
            uncertain: true,
            onAddress: (v) => address = v,
          ),
        ),
      ),
    );
    expect(
      find.textContaining('AI kurang yakin dengan nomor rumah/patokan detail.', findRichText: true),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), proposal.address);
    expect(address, proposal.address);
    expect(tester.widget<AppTextField>(find.byType(AppTextField)).maxLines, 3);
  });
  testWidgets('service preserves all options and disabled callback', (tester) async {
    var edits = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProposalServiceSection(
              review: ProposalReview(proposal, null, serviceFixtures),
              draft: draft,
              enabled: true,
              onService: (_) => edits++,
              onWeight: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Ubah'));
    await tester.pumpAndSettle();
    final sheet = find.byType(BottomSheet);
    for (final service in serviceFixtures) {
      expect(find.descendant(of: sheet, matching: find.text(service.name)), findsOneWidget);
    }
    await tester.tap(
      find.descendant(of: sheet, matching: find.text(serviceFixtures.last.name)),
    );
    await tester.pumpAndSettle();
    expect(edits, 1);
  });
  testWidgets('service card shows chip, total and delegates two links', (tester) async {
    var service = 0, weight = 0;
    Future<void> pump(String? chipLabel, String? total) => tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ProposalServiceCardSection(
            serviceName: 'Cuci Setrika',
            weight: chipLabel,
            total: total,
            kilo: true,
            enabled: true,
            onChangeService: () => service++,
            onChangeWeight: () => weight++,
          ),
        ),
      ),
    );
    await pump(null, null);
    expect(find.text('LAYANAN'), findsOneWidget);
    expect(find.text('Cuci Setrika'), findsOneWidget);
    expect(find.text('Belum diketahui'), findsOneWidget);
    expect(find.text('Belum dihitung'), findsOneWidget);
    await tester.tap(find.text('Ubah'));
    await tester.tap(find.text('Isi berat'));
    expect(service, 1);
    expect(weight, 1);
    await pump('4,5 kg', 'Rp40.500');
    expect(find.text('4,5 kg'), findsOneWidget);
    expect(find.text('Rp40.500'), findsOneWidget);
  });
  testWidgets('privacy retains original AI promise', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: ProposalPrivacySection()),
      ),
    );
    expect(find.text(NoticeAi.message), findsOneWidget);
  });
}
