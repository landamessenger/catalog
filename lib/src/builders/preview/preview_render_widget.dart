import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

abstract class PreviewRenderWidget extends StatefulWidget {
  final GlobalKey widgetKey;

  final Dummy Function() dummyBuilder;

  const PreviewRenderWidget({
    super.key,
    required this.widgetKey,
    required this.dummyBuilder,
  });

  @override
  State<StatefulWidget> createState() {
    final state = createPreviewState();
    final dummy = dummyBuilder();
    if (dummy.isDeviceDummy()) {
      Catalog().widgetDevicePreviewMap[this] = state;
    } else {
      Catalog().widgetBasicPreviewMap[this] = state;
    }
    return state;
  }

  PreviewBoundaryState createPreviewState();
}
