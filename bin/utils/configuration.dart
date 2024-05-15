import 'dart:convert';
import 'dart:io';

import 'package:catalog/src/annotations/preview.dart';
import 'package:yaml/yaml.dart';

import 'exceptions.dart';

const configId = 'catalog';
const nammeId = 'name';
const dependenciesId = 'dependencies';
const pageNameId = 'pageFile';
const assetsId = 'assets';
const kDebugMode = true;

String introMessage(String version) => '''
  ════════════════════════════════════════════
     📘 Catalog (v $version)                
  ════════════════════════════════════════════
  ''';

Map<String, dynamic> loadConfigFile() {
  final File file = File("pubspec.yaml");
  final String yamlString = file.readAsStringSync();
  // ignore: always_specify_types
  final Map yamlMap = loadYaml(yamlString);

  if (yamlMap[configId] is! Map) {
    stderr.writeln(
      const NoConfigFoundException(
        'Check your config file pubspec.yaml has a `$configId` section',
      ),
    );
    exit(1);
  }

  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap[configId].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}

Map<String, dynamic> loadDependenciesFile() {
  final File file = File("pubspec.yaml");
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

String loadId() {
  final File file = File("pubspec.yaml");
  final String yamlString = file.readAsStringSync();
  // ignore: always_specify_types
  final Map yamlMap = loadYaml(yamlString);

  return yamlMap[nammeId];
}

Future<Preview?> previewOnFile(
  dynamic config,
  String originalFilePath,
) async {
  try {
    var output = './${config['base']}/${config['output']}/';
    var fileName = 'process.dart';

    File originalFile = File(originalFilePath);
    var originalContent = originalFile.readAsStringSync();

    var original =
        'Preview${originalContent.split('@Preview')[1].split(')').first});';
    var dir = Directory(output);
    await dir.create(recursive: true);
    File file = File('$output/$fileName');
    var content = '''
import 'dart:convert';

import 'package:catalog/src/base/serial.dart';

class Preview implements Serial<Preview> {
  final String id;
  final String path;
  final String description;
  final bool usesDummies;
  final List<String> dummyParameters;
  final List<dynamic> listParameters;
  final Map<String, dynamic> parameters;

  const Preview({
    required this.id,
    required this.path,
    this.description = '',
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

void main(List<String> arguments) async {
  var preview = $original
  print(jsonEncode(preview.toJson()));
}
    ''';
    file.writeAsStringSync(content);

    var path = file.absolute.path;
    var result = await Process.run('dart', ['run', path]);
    var preview =
        const Preview(id: '', path: '').fromJson(jsonDecode(result.stdout));
    return preview;
  } catch (e) {
    print(e);
    return null;
  }
}
