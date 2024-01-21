import 'dart:convert';
import 'dart:ui' as ui;

import 'package:catalog/catalog.dart';
import 'package:catalog/src/extensions/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

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

void processBasicScreenshots() async {
  final entries = Catalog().widgetBasicPreviewMap.entries.toList();
  for (final w in entries) {
    await w.value.capture();
  }
}

void processDeviceScreenshots() async {
  final entries = Catalog().widgetDevicePreviewMap.entries.toList();
  for (final w in entries) {
    await w.value.capture();
  }
}

Future<void> startCapturing({
  required Dummy dummy,
  required Future<String> Function() callback,
  required Function() refreshContent,
  required Function() onStartCapturing,
  required Function() onFinishCapturing,
}) async {
  onStartCapturing();
  if (dummy.screenshot.locales.isNotEmpty) {
    for (final locale in dummy.screenshot.locales) {
      final outputFolder =
          await dummy.screenshot.outputFolder?.call(locale) ?? '';
      await Catalog().beforeCapture(locale);
      refreshContent();
      await Future.delayed(const Duration(seconds: 1));

      for (final ss in dummy.screenshot.screenshots) {
        ss.setLocale(locale);
        await _processScreenshot(
          mode: dummy.screenshot.background.toStringName(),
          outputFolder: outputFolder,
          fileName: ss.fileName,
          callback: callback,
          height: ss.size.height,
          width: ss.size.width,
        );
      }
    }
  } else {
    final outputFolder = await dummy.screenshot.outputFolder?.call(null) ?? '';
    if (dummy.screenshot.screenshots.isNotEmpty) {
      for (final ss in dummy.screenshot.screenshots) {
        await _processScreenshot(
          mode: dummy.screenshot.background.toStringName(),
          outputFolder: outputFolder,
          fileName: ss.fileName,
          callback: callback,
          height: ss.size.height,
          width: ss.size.width,
        );
      }
    } else {
      await _processScreenshot(
        mode: dummy.screenshot.background.toStringName(),
        outputFolder: outputFolder,
        fileName: '${DateTime.now().millisecondsSinceEpoch}.png',
        callback: callback,
        height: 0.0,
        width: 0.0,
      );
    }
  }
  onFinishCapturing();
}

Future<void> _processScreenshot({
  required String mode,
  required String outputFolder,
  required String fileName,
  required double height,
  required double width,
  required Future<String> Function() callback,
}) async {
  final base64Image = await callback();
  final response = await http.post(
    Uri.parse('http://127.0.0.1:12345'),
    body: jsonEncode({
      'mode': mode,
      'outputFolder': outputFolder.addFinalSlash().addCurrentFolderDot(),
      'fileName': fileName,
      'height': height,
      'width': width,
      'image': base64Image,
    }),
  );
  if (response.statusCode == 200) {
    print('Response data: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}
