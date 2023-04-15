import 'dart:convert';

import 'package:catalog/src/annotations/preview.dart';
import 'package:catalog/src/builders/built_component.dart';
import 'package:catalog/src/component/component_node.dart';

abstract class Serial<T> {
  String getId();

  Map<String, dynamic> toJson();

  String stringValue() {
    var map = toJson();
    return jsonEncode(map);
  }

  T fromJson(Map<String, dynamic> json);

  T fromString(String value) {
    Map<String, dynamic> map = jsonDecode(value);
    return fromJson(map);
  }

  T instance();

  static Map<String, dynamic> toMap<T>(Map<String, T> map) {
    var re = <String, dynamic>{};
    if (map.isEmpty) return re;
    for (MapEntry<String, T> entry in map.entries) {
      if (entry.value is Serial) {
        re[entry.key] = (entry.value as Serial).toJson();
      } else {
        re[entry.key] = entry.value;
      }
    }
    return re;
  }

  static Map<String, T> fromComplexMap<T extends Serial<T>>(
      Map<dynamic, dynamic> map) {
    var re = <String, T>{};
    if (map.isEmpty) return re;
    for (MapEntry<dynamic, dynamic> entry in map.entries) {
      T instance = _instance<T>(T);
      var k = entry.key as String;
      instance.fromJson(normalizeMap(entry.value));
      re[k] = instance;
    }
    return re;
  }

  static Map<String, dynamic> normalizeMap(Map<dynamic, dynamic> map) {
    var entries = map.entries.toList();
    var m = <String, dynamic>{};
    for (var entry in entries) {
      var key = entry.key as String;
      m[key] = entry.value as dynamic;
    }
    return m;
  }

  static T _instance<T extends Serial<T>>(Type t) {
    if (instanceMap.length != instances.length) {
      instanceMap.clear();
      for (dynamic i in instances) {
        instanceMap[i.runtimeType.toString()] = i;
      }
    }
    String val = t.toString();
    if (instanceMap[val] == null) {
      throw ('Missing class serialization: $val');
    }
    return instanceMap[val].instance();
  }

  static Map<String, dynamic> instanceMap = <String, dynamic>{};

  static List<dynamic> instances = <dynamic>[
    ComponentNode(),
    BuiltComponent(),
    const Preview(id: '', path: ''),
  ];

  static Map<String, dynamic> internalLinkerToMap(map) {
    var re = <String, dynamic>{};
    if (map == null || map.length == 0) return re;
    try {
      for (MapEntry<dynamic, dynamic> entry in map.entries) {
        re[entry.key] = entry.value;
      }
    } catch (e) {
      for (MapEntry<String, dynamic> entry in map.entries) {
        re[entry.key] = entry.value;
      }
    }
    return re;
  }
}

extension PrettyJson on Map<String, dynamic> {
  String toPrettyString() {
    var encoder = const JsonEncoder.withIndent('     ');
    return encoder.convert(this);
  }
}
