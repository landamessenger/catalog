import 'dart:convert';

import 'package:catalog/src/base/serial.dart';

class Preview implements Serial<Preview> {
  final String description;
  final List<String> parameters;

  const Preview({
    this.description = '',
    this.parameters = const [],
  });

  @override
  Preview fromJson(Map<String, dynamic> json) => Preview(
        description: json['description'] ?? '',
        parameters: Serial.listObjectFromBasicType<String>(
          json['parameters'] ?? [],
        ),
      );

  @override
  String getId() => '';

  @override
  Preview instance() => const Preview();

  @override
  Map<String, dynamic> toJson() => {
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
    String? description,
    List<String>? parameters,
  }) =>
      Preview(
        description: description ?? this.description,
        parameters: parameters ?? this.parameters,
      );
}
