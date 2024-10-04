import 'dart:convert';

import 'package:catalog/src/base/serial.dart';

class InternalPreview implements Serial<InternalPreview> {
  final String id;
  final String path;
  final String description;
  final List<String> parameters;

  const InternalPreview({
    this.id = '',
    this.path = '',
    this.description = '',
    this.parameters = const [],
  });

  @override
  InternalPreview fromJson(Map<String, dynamic> json) => InternalPreview(
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
  InternalPreview instance() => const InternalPreview(id: '', path: '');

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'path': path,
        'description': description,
        'parameters': parameters,
      };

  @override
  InternalPreview fromString(String value) {
    Map<String, dynamic> map = jsonDecode(value);
    return fromJson(map);
  }

  @override
  String stringValue() {
    var map = toJson();
    return jsonEncode(map);
  }

  InternalPreview copyWith({
    String? id,
    String? path,
    String? description,
    List<String>? parameters,
  }) =>
      InternalPreview(
        id: id ?? this.id,
        path: path ?? this.path,
        description: description ?? this.description,
        parameters: parameters ?? this.parameters,
      );
}
