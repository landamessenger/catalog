import 'dart:convert';

import 'package:catalog/src/base/serial.dart';

class Preview implements Serial<Preview> {
  final String id;
  final String path;
  final String description;
  final List<Object> listParameters;
  final Map<String, Object> parameters;

  const Preview({
    required this.id,
    required this.path,
    this.description = '',
    this.parameters = const {},
    this.listParameters = const [],
  });

  @override
  Preview fromJson(Map<String, dynamic> json) => Preview(
        id: json['id'] ?? '',
        path: json['path'] ?? '',
        description: json['description'] ?? '',
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
