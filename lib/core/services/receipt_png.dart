import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_text_styles.dart';

/// Renders the complete receipt, including content outside the screen viewport.
Future<Uint8List> receiptPng(ReceiptDocumentData data) async {
  const width = 640, padding = 32.0;
  final recording = ui.PictureRecorder();
  final canvas = ui.Canvas(recording);
  var y = padding;
  final lines = <({String text, bool strong})>[
    (text: data.title, strong: true),
    for (final line in data.header) (text: line, strong: false),
    for (final group in data.groups) ...[
      (text: '', strong: false),
      for (final row in group) ...[
        (text: '${row.label}: ${row.value}', strong: row.emphasis),
        if (row.detail != null) (text: row.detail!, strong: false),
        if (row.valueDetail != null) (text: row.valueDetail!, strong: false),
      ],
    ],
    (text: '', strong: false),
    (text: data.status, strong: true),
    if (data.statusDetail.isNotEmpty) (text: data.statusDetail, strong: false),
    for (final line in data.footer) (text: line, strong: false),
  ];
  for (final line in lines) {
    final painter = TextPainter(
      text: TextSpan(
        text: line.text.isEmpty ? ' ' : line.text,
        style: (line.strong ? AppTextStyles.section : AppTextStyles.body).copyWith(
          color: AppColors.ink,
          fontSize: AppTextStyles.titleRoot.fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width - padding * 2);
    painter.paint(canvas, ui.Offset(padding, y));
    y += painter.height + 8;
    painter.dispose();
  }
  final content = recording.endRecording();
  final background = ui.PictureRecorder();
  final output = ui.Canvas(background);
  output.drawRect(
    ui.Rect.fromLTWH(0, 0, width.toDouble(), y + padding),
    ui.Paint()..color = AppColors.surface,
  );
  output.drawPicture(content);
  final picture = background.endRecording();
  final image = await picture.toImage(width, (y + padding).ceil());
  try {
    return (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  } finally {
    image.dispose();
    picture.dispose();
    content.dispose();
  }
}
