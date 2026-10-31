import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/proposals/data/proposal_fixtures.dart';

String proposalStatusLabel(ProposalStatus status) => switch (status) {
  ProposalStatus.menunggu => 'Menunggu',
  ProposalStatus.disetujui => 'Disetujui',
  ProposalStatus.ditolak => 'Ditolak',
  ProposalStatus.ditutupOtomatis => 'Ditutup otomatis',
};

class ProposalHistory {
  const ProposalHistory(this.rows);
  final List<Proposal> rows;
  String get historicalSummary =>
      'Riwayat lama: ${proposalHistoryBaseline[ProposalStatus.disetujui]} disetujui, ${proposalHistoryBaseline[ProposalStatus.ditolak]} ditolak, ${proposalHistoryBaseline[ProposalStatus.ditutupOtomatis]} ditutup otomatis (ringkasan).';
  int count(ProposalStatus status) =>
      (proposalHistoryBaseline[status] ?? 0) + rows.where((p) => p.status == status).length;
  List<String> get chips => [
    'Semua',
    for (final s in ProposalStatus.values) '${proposalStatusLabel(s)} ${count(s)}',
  ];
  List<Proposal> visible(int filter) =>
      rows.where((p) => filter == 0 || p.status == ProposalStatus.values[filter - 1]).toList();
}

final proposalHistoryProvider = FutureProvider<ProposalHistory>((ref) async {
  final rows = List<Proposal>.of(await ref.watch(proposalRepositoryProvider).getProposals());
  rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return ProposalHistory(rows);
});

class ProposalHistoryFilter extends Notifier<int> {
  @override
  int build() => 0;
  void select(int value) => state = value;
}

final proposalHistoryFilterProvider = NotifierProvider<ProposalHistoryFilter, int>(
  ProposalHistoryFilter.new,
);
