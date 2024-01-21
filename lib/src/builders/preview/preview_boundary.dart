import 'package:catalog/catalog.dart';
import 'package:catalog/src/builders/screenshots/op/screenshot_process.dart';
import 'package:catalog/src/widgets/preview_render_widget.dart';
import 'package:flutter/material.dart';

import 'preview_dummy_basic.dart';
import 'preview_dummy_device.dart';

class PreviewBoundary extends PreviewRenderWidget {
  final Widget Function(BuildContext context, Dummy dummy) builder;

  const PreviewBoundary({
    super.key,
    required super.widgetKey,
    required super.dummyBuilder,
    required this.builder,
  });

  @override
  PreviewBoundaryState createPreviewState() => PreviewBoundaryState();
}

class PreviewBoundaryState extends State<PreviewBoundary> {
  bool capturing = false;

  @override
  Widget build(BuildContext context) {
    Catalog().pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final dummy = widget.dummyBuilder();
    final deviceInfo = dummy.device.deviceInfo;
    if (deviceInfo == null) {
      return PreviewDummyBasic(
        capturing: capturing,
        widgetKey: widget.widgetKey,
        dummy: dummy,
        builder: widget.builder,
        startCapturing: () => startCapturing(),
      );
    }
    return PreviewDummyDevice(
      capturing: capturing,
      widgetKey: widget.widgetKey,
      dummy: dummy,
      builder: widget.builder,
      deviceInfo: deviceInfo,
      startCapturing: () => startCapturing(),
    );
  }

  Future<void> startCapturing() async {
    await Catalog().startCapturing(
      dummy: widget.dummyBuilder(),
      callback: () => captureScreenshot(widget.widgetKey),
      refreshContent: () => setState(() {
        // nothing to do here
      }),
      onStartCapturing: () => setState(() {
        capturing = true;
      }),
      onFinishCapturing: () => setState(() {
        capturing = false;
      }),
    );
  }
}
