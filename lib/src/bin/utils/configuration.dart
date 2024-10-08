import 'dart:convert';
import 'dart:io';

import 'package:catalog/src/annotations/internal_preview.dart';
import 'package:yaml/yaml.dart';

import 'exceptions.dart';

const catalogConfigId = 'catalog';
const objectConfigId = 'object';
const nameId = 'name';
const dependenciesId = 'dependencies';
const pageNameId = 'pageFile';
const assetsId = 'assets';
const kDebugMode = true;

String introMessage(String version) => '''
  ════════════════════════════════════════════
     📘 Catalog (v $version)                
  ════════════════════════════════════════════
  ''';

Map<String, dynamic> loadCatalogConfigFile(String basePath) {
  final File file = File("${basePath}pubspec.yaml");
  final String yamlString = file.readAsStringSync();
  // ignore: always_specify_types
  final Map yamlMap = loadYaml(yamlString);

  if (yamlMap[catalogConfigId] is! Map) {
    stderr.writeln(
      const NoConfigFoundException(
        'Check your config file pubspec.yaml has a `$catalogConfigId` section',
      ),
    );
    exit(1);
  }

  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap[catalogConfigId].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}

Map<String, dynamic> loadObjectConfigFile(String basePath) {
  final File file = File("${basePath}pubspec.yaml");
  final String yamlString = file.readAsStringSync();
  // ignore: always_specify_types
  final Map yamlMap = loadYaml(yamlString);

  if (yamlMap[objectConfigId] == null) return {};

  if (yamlMap[objectConfigId] is! Map) {
    stderr.writeln(
      const NoConfigFoundException(
        'Check your config file pubspec.yaml has a `$objectConfigId` section',
      ),
    );
    exit(1);
  }

  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap[objectConfigId].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}

Map<String, dynamic> loadDependenciesFile(String basePath) {
  final File file = File("${basePath}pubspec.yaml");
  final String yamlString = file.readAsStringSync();
  // ignore: always_specify_types
  final Map yamlMap = loadYaml(yamlString);

  if (yamlMap[dependenciesId] is! Map) {
    stderr.writeln(
      const NoConfigFoundException(
        'Check your config file pubspec.yaml has a `$dependenciesId` section',
      ),
    );
    exit(1);
  }

  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap[dependenciesId].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}

String loadId(String basePath) {
  final File file = File("${basePath}pubspec.yaml");
  final String yamlString = file.readAsStringSync();
  // ignore: always_specify_types
  final Map yamlMap = loadYaml(yamlString);

  return yamlMap[nameId];
}

Future<InternalPreview?> previewOnFile(
  String basePath,
  dynamic config,
  String originalFilePath,
) async {
  try {
    var output = './$basePath${config['base']}/${config['output']}/';
    var fileName = 'process.dart';

    File originalFile = File(originalFilePath);
    var originalContent = originalFile.readAsStringSync();

    var original =
        'InternalPreview${originalContent.split('@Preview')[1].split(')').first});';
    var dir = Directory(output);
    await dir.create(recursive: true);

    File file = File('$output/$fileName');
    var content = '''
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

void main(List<String> arguments) async {
  var preview = $original
  print(jsonEncode(preview.toJson()));
}
    ''';
    file.writeAsStringSync(content);

    var path = file.absolute.path;
    var result = await Process.run('dart', ['run', path]);
    var preview = InternalPreview(
      id: '',
      path: '',
    ).fromJson(
      jsonDecode(result.stdout),
    );

    if (preview.id.isEmpty) {
      preview = preview.copyWith(
        id: originalFilePath.split('/').last.split('.').first,
      );
    }

    if (preview.path.isEmpty) {
      if (originalFilePath.contains('/catalog')) {
        preview = preview.copyWith(
          path: originalFilePath.split('/lib/').last.split('/catalog').first,
        );
      } else {
        var parts = originalFilePath.split('/lib/').last.split('/');
        preview = preview.copyWith(
          path: parts.sublist(0, parts.length - 1).join('/'),
        );
      }
    }

    return preview;
  } catch (e) {
    print(e);
    return null;
  }
}
