import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_arch.dart';

Registry registry({
  Set<String> routes = const {'AntreanPage'},
  Set<String> debt = const {},
}) => (all: {'AppText'}, stateful: {}, routes: routes, debt: debt);

String page(String name) =>
    '''
class $name extends StatelessWidget {
  const $name({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox();
}
''';

String section(String name, {String base = 'StatelessWidget', String imports = ''}) =>
    '''
$imports
class $name extends $base {
  const $name({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox();
}
''';

void main() {
  const orderPage = 'lib/features/orders/pages/order_summary_page.dart';

  test('Page non-rute ditolak, Page rute diterima', () {
    final bad = checkFile(orderPage, page('OrderSummaryPage'), registry());
    expect(bad.any((e) => e.contains('Page bukan rute')), isTrue);

    final ok = checkFile(
      'lib/features/orders/pages/antrean_page.dart',
      page('AntreanPage'),
      registry(),
    );
    expect(ok, isEmpty);
  });

  test('Section hanya sah di widgets/*_section.dart sebagai StatelessWidget', () {
    final inPages = checkFile(
      orderPage,
      section('OrderSummarySection'),
      registry(),
    );
    expect(inPages.any((e) => e.contains('Section hanya di')), isTrue);

    final ok = checkFile(
      'lib/features/orders/widgets/order_summary_section.dart',
      section('OrderSummarySection'),
      registry(),
    );
    expect(ok, isEmpty);

    const path = 'lib/features/orders/widgets/order_detail_section.dart';
    final consumer = checkFile(
      path,
      section('OrderDetailSection', base: 'ConsumerWidget'),
      registry(),
    );
    expect(consumer.any((e) => e.contains('harus StatelessWidget')), isTrue);

    final debtOk = checkFile(
      path,
      section('OrderDetailSection', base: 'ConsumerWidget'),
      registry(debt: {path}),
    );
    expect(debtOk, isEmpty);
  });

  test('Section tanpa Riverpod dan go_router kecuali tercatat utang', () {
    const path = 'lib/features/orders/widgets/order_summary_section.dart';
    final riverpod = checkFile(
      path,
      section(
        'OrderSummarySection',
        imports: "import 'package:flutter_riverpod/flutter_riverpod.dart';",
      ),
      registry(),
    );
    expect(riverpod.any((e) => e.contains('tanpa Riverpod')), isTrue);

    final router = checkFile(
      path,
      section(
        'OrderSummarySection',
        imports: "import 'package:go_router/go_router.dart';",
      ),
      registry(),
    );
    expect(router.any((e) => e.contains('tanpa go_router')), isTrue);

    final debtOk = checkFile(
      path,
      section(
        'OrderSummarySection',
        imports: "import 'package:go_router/go_router.dart';",
      ),
      registry(debt: {path}),
    );
    expect(debtOk, isEmpty);
  });

  test('Section dilarang memakai widgets fitur lain', () {
    const path = 'lib/features/orders/widgets/order_summary_section.dart';
    final bad = checkFile(
      path,
      section(
        'OrderSummarySection',
        imports: "import 'package:laurum/features/customers/widgets/customer_row_section.dart';",
      ),
      registry(),
    );
    expect(bad.any((e) => e.contains('widgets/ fitur lain')), isTrue);

    final ok = checkFile(
      path,
      section(
        'OrderSummarySection',
        imports: "import 'package:laurum/features/orders/widgets/order_items_section.dart';",
      ),
      registry(),
    );
    expect(ok, isEmpty);
  });

  test('Isi pages hanya page, sheet, flow, routes, app_router', () {
    final bad = checkFile(
      'lib/features/orders/pages/order_cancel.dart',
      'Future<void> cancel() async {}',
      registry(),
    );
    expect(bad.any((e) => e.contains('pindah ke state/')), isTrue);

    final ok = checkFile(
      'lib/features/orders/pages/order_cancel_flow.dart',
      'Future<void> cancel() async {}',
      registry(),
    );
    expect(ok, isEmpty);
  });

  test('state tanpa widget dan tanpa impor UI', () {
    final widgetInState = checkFile(
      'lib/features/orders/state/order_detail_state.dart',
      page('OrderDetailPage'),
      registry(routes: {}),
    );
    expect(
      widgetInState.any((e) => e.contains('state/ tanpa kelas Widget')),
      isTrue,
    );

    final material = checkFile(
      'lib/features/orders/state/order_detail_state.dart',
      "import 'package:flutter/material.dart';",
      registry(),
    );
    expect(material.any((e) => e.contains('state/ tanpa UI')), isTrue);

    final router = checkFile(
      'lib/features/orders/state/order_detail_state.dart',
      "import 'package:go_router/go_router.dart';",
      registry(),
    );
    expect(router.any((e) => e.contains('state/ tanpa UI')), isTrue);
  });

  test('showModalBottomSheet hanya di AppBottomSheet', () {
    final bad = checkFile(
      'lib/features/orders/pages/order_detail_page.dart',
      'void open(BuildContext context) => showModalBottomSheet(context: context);',
      registry(),
    );
    expect(bad.any((e) => e.contains('AppBottomSheet.show')), isTrue);

    final ok = checkFile(
      'lib/shared/widgets/organisms/app_bottom_sheet.dart',
      'void open(BuildContext context) => showModalBottomSheet(context: context);',
      registry(),
    );
    expect(ok, isEmpty);
  });
}
