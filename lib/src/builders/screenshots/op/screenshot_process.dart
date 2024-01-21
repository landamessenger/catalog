import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:catalog/catalog.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

Future<String> captureScreenshot(GlobalKey widgetKey) async {
  await Future.delayed(const Duration(seconds: 1));
  final boundary =
      widgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  final image = await boundary?.toImage(
    pixelRatio: Catalog().pixelRatio,
  );
  final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) {
    return '';
  }
  return base64.encode(byteData.buffer.asUint8List().toList());
}
