import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/organisms/proposal_card.dart';

import '../widgetbook/organisms/proposal_card_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('ProposalCard switches review action and delegates both callbacks', (tester) async {
    var approvals = 0, rejections = 0;
    for (final review in [true, false]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ProposalCard(
              customerName: 'Pak Rudi',
              summary: 'Batalkan pesanan A-0139',
              needsReview: review,
              reviewText: 'A-0139',
              onApprove: () => approvals++,
              onReject: () => rejections++,
            ),
          ),
        ),
      );
      expect(
        tester.widget<AppCard>(find.byType(AppCard)).rail,
        review ? AppCardRail.warning : AppCardRail.none,
      );
      expect(find.text('Periksa bagian ini'), review ? findsOneWidget : findsNothing);
      await tester.tap(find.text(review ? 'Periksa' : 'Setujui'));
      await tester.tap(find.text('Tolak'));
    }
    expect(approvals, 2);
    expect(rejections, 2);
  });
  registerOrganismGallery('proposal_card', proposalCardUseCase.builder, height: 1100);
}
