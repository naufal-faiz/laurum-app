import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:laurum/shared/widgets/molecules/notice_ai.dart';

import '../widgetbook/molecules/notice_ai_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('NoticeAi renders and honors callbacks', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: NoticeAi())));
    expect(
      find.text(
        'AI hanya membaca pesan WhatsApp. AI tidak pernah mengirim pesan atau mengubah order tanpa persetujuan Anda.',
      ),
      findsOneWidget,
    );
  });
  registerMoleculeGolden('notice_ai', noticeAiUseCase.builder);
}
