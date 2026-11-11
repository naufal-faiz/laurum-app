import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/proposals/widgets/proposal_address_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_customer_fields_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_privacy_section.dart';
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
              draft: draft.copyWith(name: '', phone: ''),
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
    expect(find.text('AI kurang yakin dengan nomor rumah/patokan detail.'), findsOneWidget);
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
              enabled: false,
              onService: (_) => edits++,
            ),
          ),
        ),
      ),
    );
    for (final service in serviceFixtures) {
      expect(find.text(service.name), findsOneWidget);
    }
    await tester.tap(find.text(serviceFixtures.first.name));
    expect(edits, 0);
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
