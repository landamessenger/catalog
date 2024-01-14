import 'dart:convert';

import 'package:catalog/src/base/serial.dart';

class Preview implements Serial<Preview> {
  final String id;
  final String path;
  final String description;
  final bool usesDummies;
  final String deviceInfo;
  final String orientation;
  final List<String> dummyParameters;
  final List<dynamic> listParameters;
  final Map<String, dynamic> parameters;

  const Preview({
    required this.id,
    required this.path,
    this.description = '',
    this.deviceInfo = '',
    this.orientation = '',
    this.usesDummies = false,
    this.parameters = const {},
    this.listParameters = const [],
    this.dummyParameters = const [],
  });

  @override
  Preview fromJson(Map<String, dynamic> json) => Preview(
        id: json['id'] ?? '',
        path: json['path'] ?? '',
        description: json['description'] ?? '',
        deviceInfo: json['deviceInfo'] ?? '',
        orientation: json['orientation'] ?? '',
        usesDummies: json['usesDummies'] ?? false,
        dummyParameters: Serial.listObjectFromBasicType<String>(
          json['dummyParameters'] ?? [],
        ),
        listParameters: json['listParameters'] ?? [],
        parameters: json['parameters'] ?? {},
      );

  @override
  String getId() => id;

  @override
  Preview instance() => const Preview(id: '', path: '');

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'path': path,
        'description': description,
        'deviceInfo': deviceInfo,
        'orientation': orientation,
        'usesDummies': usesDummies,
        'listParameters': listParameters,
        'dummyParameters': dummyParameters,
        'parameters': parameters,
      };

  @override
  Preview fromString(String value) {
    Map<String, dynamic> map = jsonDecode(value);
    return fromJson(map);
  }

  @override
  String stringValue() {
    var map = toJson();
    return jsonEncode(map);
  }
}
