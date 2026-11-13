import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/organisms/receipt_document.dart';

/// Paints the same widget as the preview, at full height and 2x resolution.
Future<Uint8List> receiptPng(ReceiptDocumentData data) async {
  final boundary = RenderRepaintBoundary();
  final pipeline = PipelineOwner();
  final focus = FocusManager();
  final owner = BuildOwner(focusManager: focus);
  ViewConfiguration configuration(double height) => ViewConfiguration(
    logicalConstraints: BoxConstraints.tightFor(width: data.width, height: height),
    physicalConstraints: BoxConstraints.tightFor(width: data.width, height: height),
  );
  final view = RenderView(
    view: ui.PlatformDispatcher.instance.views.first,
    configuration: configuration(1),
    child: boundary,
  );
  pipeline.rootNode = view;
  view.prepareInitialFrame();
  final root = RenderObjectToWidgetAdapter<RenderBox>(
    container: boundary,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(data.width, 1)),
        child: Theme(
          data: AppTheme.light,
          child: Material(
            color: AppColors.surface,
            child: ReceiptDocument(data: data),
          ),
        ),
      ),
    ),
  ).attachToRenderTree(owner);
  try {
    owner.buildScope(root);
    view.configuration = configuration(boundary.getMaxIntrinsicHeight(data.width));
    pipeline.flushLayout();
    pipeline.flushCompositingBits();
    pipeline.flushPaint();
    final image = await boundary.toImage(pixelRatio: 2);
    try {
      return (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  } finally {
    RenderObjectToWidgetAdapter<RenderBox>(container: boundary).attachToRenderTree(owner, root);
    owner.buildScope(root);
    owner.finalizeTree();
    pipeline.rootNode = null;
    view.child = null;
    boundary.dispose();
    view.dispose();
    pipeline.dispose();
    focus.dispose();
  }
}
