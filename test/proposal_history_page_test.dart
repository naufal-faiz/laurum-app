import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('history filters baseline and opens actual proposal', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya/ai/riwayat');
    expect(find.text('Menunggu 3'), findsOneWidget);
    await tester.tap(find.text('Bu Rina'));
    await tester.pumpAndSettle();
    expect(find.text('Hasil bacaan AI'), findsOneWidget);
    host.router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Disetujui 142'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada rincian usulan'), findsOneWidget);
    expect(find.textContaining('Riwayat lama:'), findsOneWidget);
  });
  testWidgets('history load failure can retry', (tester) async {
    var calls = 0;
    final scope = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        ...dummyRepositoryOverrides,
        proposalHistoryProvider.overrideWith((ref) async {
          if (calls++ == 0) throw StateError('offline');
          return const ProposalHistory([]);
        }),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/lainnya/ai/riwayat');
    expect(find.text('Gagal memuat riwayat'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada rincian usulan'), findsOneWidget);
  });
  testWidgets('detail read failure retries both review and draft', (tester) async {
    var calls = 0;
    final scope = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        ...dummyRepositoryOverrides,
        proposalReviewProvider('missing').overrideWith((ref) async {
          if (calls++ == 0) throw StateError('offline');
          return null;
        }),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/antrean/usulan/missing');
    expect(find.text('Coba lagi'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Usulan tidak ditemukan'), findsOneWidget);
  });
}
