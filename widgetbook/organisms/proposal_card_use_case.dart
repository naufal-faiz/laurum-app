import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/proposal_card.dart';
import 'package:widgetbook/widgetbook.dart';

final proposalCardUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        for (final proposal in proposalFixtures)
          ProposalCard(
            customerName: proposal.customerId == null
                ? proposal.customerName
                : customerFixtures.singleWhere((c) => c.id == proposal.customerId).name,
            summary: proposal.sourceText,
            timeLabel: Formatters.jam(proposal.createdAt),
            needsReview: proposal.uncertainAddress || proposal.cancelRequested,
            reviewText: proposal.uncertainAddress || proposal.cancelRequested
                ? proposal.sourceText
                : '',
            onApprove: proposal == proposalFixtures.last ? null : () {},
            onReject: proposal == proposalFixtures.last ? null : () {},
          ),
      ],
    ),
  ),
);
