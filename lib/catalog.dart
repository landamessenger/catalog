library catalog;

import 'dart:convert';
import 'dart:typed_data';

import 'package:catalog/src/component/component_node.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'package:catalog/src/annotations/preview.dart';
export 'package:catalog/src/builders/preview_scaffold.dart';
export 'package:catalog/src/component/component_node.dart';
export 'package:catalog/src/dummy.dart';
export 'package:catalog/src/embed/flutter_fanacy_tree_view/flutter_fancy_tree_view.dart';
export 'package:catalog/src/preview.dart';
export 'package:catalog/src/widget_runner.dart';

/// A Calculator.
class Catalog {
  static Catalog? _instance;

  Catalog._internal();

  factory Catalog() {
    _instance ??= Catalog._internal();
    return _instance!;
  }

  final global = GlobalKey();
  final key = GlobalKey<ScaffoldMessengerState>();

  List<RouteBase> routes = [];

  List<RouteBase> catalog() {
    return routes;
  }

  String path = "assets/preview_config.json";

  Future<Uint8List> Function(Uint8List data) process = (data) async => data;

  ComponentNode node(String data) => ComponentNode().fromJson(jsonDecode(data));

  ComponentNode? currentNode;

  Catalog config({
    String? path,
    Future<Uint8List> Function(Uint8List data)? process,
  }) {
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
