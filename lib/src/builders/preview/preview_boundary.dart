import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'preview_dummy_basic.dart';
import 'preview_dummy_device.dart';

class PreviewBoundary extends StatefulWidget {
  final GlobalKey widgetKey = GlobalKey();

  final int index;

  final Dummy Function() dummyBuilder;

  final Widget Function(BuildContext context, Dummy dummy) builder;

  PreviewBoundary({
    super.key,
    required this.builder,
    required this.dummyBuilder,
    required this.index,
  });

  @override
  State<StatefulWidget> createState() => PreviewBoundaryState();
}

class PreviewBoundaryState extends State<PreviewBoundary> {
  bool capturing = false;

  @override
  Widget build(BuildContext context) {
    Catalog().activePreviews[widget.index.toString()] = widget.widgetKey;
    return Builder(
      builder: (context) {
        final dummy = widget.dummyBuilder();
        final deviceInfo = dummy.device.deviceInfo;
        if (deviceInfo == null) {
          return PreviewDummyBasic(
            capturing: capturing,
            widgetKey: widget.widgetKey,
            dummy: dummy,
            builder: widget.builder,
            startCapturing: () => startCapturing(context),
          );
        }
        return PreviewDummyDevice(
          capturing: capturing,
          widgetKey: widget.widgetKey,
          dummy: dummy,
          builder: widget.builder,
          deviceInfo: deviceInfo,
          startCapturing: () => startCapturing(context),
        );
      },
    );
  }

  void startCapturing(BuildContext context) {
    Catalog().startCapturing(
      dummy: widget.dummyBuilder(),
      callback: () async {
        final screenShotData =
            await captureScreenshot(context, widget.widgetKey);
        return base64.encode(screenShotData?.toList() ?? []);
      },
      refreshContent: () {
        setState(() {
          // nothing to do here
        });
      },
      onStartCapturing: () {
        setState(() {
          capturing = true;
        });
      },
      onFinishCapturing: () {
        setState(() {
          capturing = false;
        });
      },
    );
  }

  Future<Uint8List?> captureScreenshot(
      BuildContext context, GlobalKey widgetKey) async {
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
