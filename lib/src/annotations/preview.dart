import 'dart:convert';

import 'package:catalog/src/base/serial.dart';

class Preview implements Serial<Preview> {
  final String id;
  final String path;
  final String description;
  final List<String> parameters;

  const Preview({
    this.id = '',
    this.path = '',
    this.description = '',
    this.parameters = const [],
  });

  @override
  Preview fromJson(Map<String, dynamic> json) => Preview(
        id: json['id'] ?? '',
        path: json['path'] ?? '',
        description: json['description'] ?? '',
        parameters: Serial.listObjectFromBasicType<String>(
          json['parameters'] ?? [],
        ),
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

  Preview copyWith({
    String? id,
    String? path,
    String? description,
    List<String>? parameters,
  }) =>
      Preview(
        id: id ?? this.id,
        path: path ?? this.path,
        description: description ?? this.description,
        parameters: parameters ?? this.parameters,
      );
}
