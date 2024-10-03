library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:catalog/src/builders/catalog/component_node.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'src/builders/preview/preview_boundary.dart';
import 'src/builders/preview/preview_render_widget.dart';

export 'package:catalog/src/annotations/preview.dart';
export 'package:catalog/src/builders/device/device.dart';
export 'package:catalog/src/builders/dummy/dummy.dart';
export 'package:catalog/src/builders/dummy/dummy_text.dart';
export 'package:catalog/src/builders/preview/parent_preview_widget.dart';
export 'package:catalog/src/builders/preview/preview_boundary.dart';
export 'package:catalog/src/builders/dummy/preview_dummy.dart';
export 'package:catalog/src/builders/catalog/preview_scaffold.dart';
export 'package:catalog/src/builders/screenshots/background.dart';
export 'package:catalog/src/builders/screenshots/op/screenshot_process.dart';
export 'package:catalog/src/builders/screenshots/screenshot.dart';
export 'package:catalog/src/builders/screenshots/types/android/android_phone.dart';
export 'package:catalog/src/builders/screenshots/types/apple/i_pad_pro.dart';
export 'package:catalog/src/builders/screenshots/types/apple/i_pad_pro_3gen.dart';
export 'package:catalog/src/builders/screenshots/types/apple/i_phone_55.dart';
export 'package:catalog/src/builders/screenshots/types/apple/i_phone_65.dart';
export 'package:catalog/src/builders/screenshots/types/apple/macos.dart';
export 'package:catalog/src/catalog_runner.dart';
export 'package:catalog/src/builders/catalog/component_node.dart';
export 'package:catalog/src/utils/constants.dart';
export 'package:catalog/src/embed/flutter_fanacy_tree_view/flutter_fancy_tree_view.dart';
export 'package:catalog/src/extensions/locale_ext.dart';
export 'package:device_frame/device_frame.dart';
export 'package:go_router/go_router.dart';

class Catalog {
  static Catalog? _instance;

  Catalog._internal();

  factory Catalog() {
    _instance ??= Catalog._internal();
    return _instance!;
  }

  Function(GoRouter router)? runnerRouterSet;

  GoRouter? router;

  bool get active => router != null;

  BuildContext get activeContext {
    if (router?.routerDelegate.navigatorKey.currentContext == null) {
      throw Exception('💥 Context not ready');
    }
    return router!.routerDelegate.navigatorKey.currentContext!;
  }

  final global = GlobalKey();
  final key = GlobalKey<ScaffoldMessengerState>();

  String path = "assets/preview_config.json";

  final Map<PreviewRenderWidget, PreviewBoundaryState> widgetBasicPreviewMap =
      {};
  final Map<PreviewRenderWidget, PreviewBoundaryState> widgetDevicePreviewMap =
      {};

  double pixelRatio = 1.0;

  void Function() onBackPressed = () => {};
  Future<Uint8List> Function(Uint8List data) process = (data) async => data;

  Future<void> Function(Locale locale) beforeCapture = (locale) async {
    // nothing to do here
  };

  ComponentNode node(String data) => ComponentNode().fromJson(jsonDecode(data));

  ComponentNode? currentNode;

  Catalog config({
    required List<String> args,
    String? path,
    void Function()? onBackPressed,
    Future<Uint8List> Function(Uint8List data)? process,
  }) {
    if (onBackPressed != null) {
      this.onBackPressed = onBackPressed;
    }
    if (path?.isNotEmpty == true) {
      this.path = path!;
    }
    if (process != null) {
      this.process = process;
    }
    return this;
  }

  Future<ComponentNode?> get(BuildContext context) async {
    if (currentNode != null) {
      return currentNode!;
    }
    try {
      final data = await DefaultAssetBundle.of(context).load(
        path,
      );
      var content =
          String.fromCharCodes(await process(data.buffer.asUint8List()));
      final jsonResult = jsonDecode(content);
      return ComponentNode().fromJson(jsonResult);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
