import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/proposals/widgets/proposal_footer_section.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

void main() {
  testWidgets('proposal footer delegates pending actions and blocks invalid draft', (tester) async {
    final proposal = proposalFixtures.last;
    final review = ProposalReview(proposal, null, serviceFixtures);
    final draft = ProposalDraft(
      name: proposal.customerName,
      phone: proposal.phone,
      address: proposal.address,
      serviceId: proposal.serviceId,
    );
    var rejects = 0;
    var approves = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ProposalFooterSection(
            review: review,
            draft: draft,
            enabled: true,
            onReject: () => rejects++,
            onApprove: () => approves++,
            onOpen: () {},
          ),
        ),
      ),
    );
    await tester.tap(find.text('Tolak'));
    await tester.tap(find.text('Setujui jadi order'));
    expect((rejects, approves), (1, 1));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ProposalFooterSection(
            review: review,
            draft: draft.copyWith(phone: ''),
            enabled: true,
            onReject: () => rejects++,
            onApprove: () => approves++,
            onOpen: () {},
          ),
        ),
      ),
    );
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Setujui jadi order')).onPressed,
      isNull,
    );
  });
  testWidgets('final proposal footer opens the linked order', (tester) async {
    final proposal = proposalFixtures.first.withStatus(ProposalStatus.disetujui);
    var opens = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ProposalFooterSection(
            review: ProposalReview(proposal, null, serviceFixtures),
            draft: const ProposalDraft(name: '', phone: '', address: '', serviceId: ''),
            enabled: false,
            onReject: () {},
            onApprove: () {},
            onOpen: () => opens++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka order'));
    expect(opens, 1);
    expect(find.text('Tolak'), findsNothing);
  });
}
