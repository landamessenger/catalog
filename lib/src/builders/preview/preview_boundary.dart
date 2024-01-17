import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../dummy.dart';
import 'preview_dummy_basic.dart';
import 'preview_dummy_device.dart';

class PreviewBoundary extends StatelessWidget {
  final GlobalKey widgetKey = GlobalKey();

  final Dummy dummy;

  final Widget Function(BuildContext context, Dummy dummy) builder;

  PreviewBoundary({
    super.key,
    required this.builder,
    required this.dummy,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widgetKey,
      child: Builder(
        builder: (context) {
          final deviceInfo = dummy.deviceInfo;
          if (deviceInfo == null) {
            return PreviewDummyBasic(
              dummy: dummy,
              builder: builder,
            );
          }
          return PreviewDummyDevice(
            dummy: dummy,
            builder: builder,
            deviceInfo: deviceInfo,
          );
        },
      ),
    );
  }

  Future<Uint8List?> captureScreenshot(BuildContext context) async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    await Future.delayed(const Duration(seconds: 1));
    final boundary =
        widgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage(
      pixelRatio: pixelRatio,
    );
    final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
