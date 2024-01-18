library catalog;

import 'dart:convert';
import 'dart:typed_data';

import 'package:catalog/src/builders/dummy.dart';
import 'package:catalog/src/builders/screenshots/types/base/base_screenshot.dart';
import 'package:catalog/src/component/component_node.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

export 'package:catalog/src/annotations/preview.dart';
export 'package:catalog/src/builders/dummy.dart';
export 'package:catalog/src/builders/dummy/dummy_text.dart';
export 'package:catalog/src/builders/preview/preview_boundary.dart';
export 'package:catalog/src/builders/preview_dummy.dart';
export 'package:catalog/src/builders/preview_scaffold.dart';
export 'package:catalog/src/builders/screenshots/screenshot.dart';
export 'package:catalog/src/builders/screenshots/types/i_pad_pro.dart';
export 'package:catalog/src/builders/screenshots/types/i_pad_pro_3gen.dart';
export 'package:catalog/src/builders/screenshots/types/i_phone_55.dart';
export 'package:catalog/src/builders/screenshots/types/i_phone_65.dart';
export 'package:catalog/src/catalog_runner.dart';
export 'package:catalog/src/component/component_node.dart';
export 'package:catalog/src/constants.dart';
export 'package:catalog/src/dummy.dart';
export 'package:catalog/src/embed/flutter_fanacy_tree_view/flutter_fancy_tree_view.dart';
export 'package:catalog/src/preview.dart';
export 'package:device_frame/device_frame.dart';
export 'package:go_router/go_router.dart';

class Catalog {
  static Catalog? _instance;

  Catalog._internal();

  factory Catalog() {
    _instance ??= Catalog._internal();
    return _instance!;
  }

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

  void Function() onBackPressed = () => {};
  Future<Uint8List> Function(Uint8List data) process = (data) async => data;

  ComponentNode node(String data) => ComponentNode().fromJson(jsonDecode(data));

  final args = <String>[];
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

  Future<void> startCapturing({
    required Dummy dummy,
    required Future<String> Function() callback,
  }) async {
    for (final ss in dummy.screenshot.screenshots) {
      await processScreenshot(screenshot: ss, callback: callback);
    }
  }

  Future<void> processScreenshot({
    required BaseScreenshot screenshot,
    required Future<String> Function() callback,
  }) async {
    final base64Image = await callback();
    final response = await http.post(
      Uri.parse('http://127.0.0.1:12345'),
      body: jsonEncode({
        'image': base64Image,
      }),
    );
    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      print('Response data: ${response.body}');
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
    }
  }
}
