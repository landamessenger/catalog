import 'dart:convert';
import 'dart:io';

import 'package:catalog/src/annotations/preview.dart';
import 'package:catalog/src/builders/built_component.dart';
import 'package:catalog/src/component/component_node.dart';
import 'package:catalog/src/extensions/string_ext.dart';
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
     catalog (v $version)                
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

Future<String?> findClassName(String path) async {
  try {
    File file = File(path);
    final content = await file.readAsString();
    return '${content.split("class ")[1].split(" ").first.trim()}()';
  } catch (e) {
    print(e);
    return null;
  }
}

Future<String?> findPreviewAnnotation(String path) async {
  try {
    File file = File(path);
    final content = await file.readAsString();
    return '@Preview${content.split("@Preview")[1].split(''')
class''').first.trim()})';
  } catch (e) {
    print(e);
    return null;
  }
}

Future<String?> findPreviewClassName(String path) async {
  try {
    File file = File(path);
    final content = await file.readAsString();
    return '${content.split("class ")[1].split(" extends PreviewWidget").first.trim()}()';
  } catch (e) {
    print(e);
    return null;
  }
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

Future<BuiltComponent?> createMdPage(
  String appId,
  String base,
  String outputPath,
  String outputFile,
  String import,
  String name,
  String path,
  String pageRoute,
  List<ComponentNode> children,
) async {
  try {
    var directory = Directory(outputPath);
    await directory.create(recursive: true);
    File file = File('$outputPath/$outputFile');
    var content = '''
/// AUTOGENERATED FILE. DO NOT EDIT

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ${name.replaceAll('()', '')}PreviewPageDummy extends StatefulWidget {
  static String routeName = '${name.toLowerCase()}';

  const ${name.replaceAll('()', '')}PreviewPageDummy({Key? key}) : super(key: key);

  @override
  ${name.replaceAll('()', '')}PreviewPageDummyState createState() => ${name.replaceAll('()', '')}PreviewPageDummyState();
}

class ${name.replaceAll('()', '')}PreviewPageDummyState extends State<${name.replaceAll('()', '')}PreviewPageDummy> {
  @override
  Widget build(BuildContext context) {
    return PreviewScaffold(
      child: ListView(
        children: [
        ''';

    for (ComponentNode node in children) {
      content += '''
          ListTile(
            title: const Text(
              '${node.id}',
              style: TextStyle(  
                color: Colors.black,
                fontSize: 16,
                letterSpacing: .3,
              ),
            ),
            onTap: () {
              context.go('/$pageRoute/$path/${node.id}');
            },
          ),
          ''';
    }

    content += '''
        ],
      ),
    );
  }
}

    ''';
    file.writeAsStringSync(content);

    var p = file.path.split(base)[1];
    var package = 'package:$appId$p';

    return BuiltComponent(
      path: file.path,
      route: path,
      package: package,
      clazzName: '${name.replaceAll('()', '')}PreviewPageDummy',
      preview: null,
    );
  } catch (e) {
    return null;
  }
}

Future<BuiltComponent?> createPage(
  String appId,
  String base,
  String outputPath,
  String outputFile,
  String prefix,
  Preview preview,
  String import,
  String name,
) async {
  try {
    var directory = Directory(outputPath);
    await directory.create(recursive: true);
    var id = preview.path.contains('/')
        ? preview.path.split('/').last
        : preview.path;
    File file = File(outputPath + outputFile.replaceAll('.$prefix.', '.'));

    var clazzName = name.replaceAll('()', '');

    var content = '''
/// AUTOGENERATED FILE. DO NOT EDIT

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import '$import';

class ${clazzName}PreviewPageDummy extends StatefulWidget {
  static String routeName = '$id';
  const ${clazzName}PreviewPageDummy({Key? key}) : super(key: key);

  @override
  ${clazzName}PreviewPageDummyState createState() => ${clazzName}PreviewPageDummyState();
}

class ${clazzName}PreviewPageDummyState extends State<${clazzName}PreviewPageDummy> {
  @override
  Widget build(BuildContext context) {
    return const $clazzName();
  }
}
    ''';
    file.writeAsStringSync(content);

    var p = file.path.split(base)[1];
    var package = 'package:$appId$p';

    return BuiltComponent(
      path: file.path,
      route: preview.path,
      package: package,
      clazzName: '${name.replaceAll('()', '')}PreviewPageDummy',
      preview: preview,
    );
  } catch (e) {
    print(e);
    return null;
  }
}

ComponentNode getNodesFrom(
  String pageRoute,
  Map<String, BuiltComponent> components,
) {
  var firstNode = ComponentNode(id: pageRoute, route: '/');

  for (var entity in components.values.toList()) {
    var parts = entity.route.split('/');
    if (parts.first == '.') {
      parts.removeAt(0);
    }
    addNode(firstNode, parts, 0, entity);
  }

  return firstNode;
}

void addNode(
  ComponentNode node,
  List<String> parts,
  int index,
  BuiltComponent component,
) {
  if (index >= parts.length) {
    return;
  }
  ComponentNode? no;
  for (var n in node.children.values.toList()) {
    if (n.id == parts[index]) {
      no = n;
      break;
    }
  }

  if (no == null) {
    no = ComponentNode(
      id: parts[index],
      route: '/${parts[index]}',
      builtComponent: parts.length - 1 == index ? component : null,
    );
    print('adding: ${no.id}');
    print('    ${no.builtComponent?.preview?.path}');
    node.children[no.id] = no;
  }

  if (index < parts.length) {
    addNode(no, parts, index + 1, component);
  }
}

Future<ComponentNode?> buildMiddlePages(
  dynamic config,
  String appId,
  ComponentNode node,
  String path,
  String pageRoute,
  int level,
) async {
  try {
    ComponentNode n = node;
    String p = path;
    if (level == 0) {
      n.builtComponent = BuiltComponent();
      n.builtComponent!.path =
          './${config['base']}/${config['output']}/${config['pageFile']}';
      n.builtComponent!.route = '';
      n.builtComponent!.clazzName = 'CatalogComponent';

      final File file = File(n.builtComponent!.path);
      var fp = file.path.split(config['base'])[1];
      n.builtComponent!.package = 'package:$appId$fp';

      for (var entry in n.children.entries) {
        var f = await buildMiddlePages(
          config,
          appId,
          entry.value,
          p,
          pageRoute,
          level + 1,
        );
        if (f == null) continue;
        n.children[entry.key] = f;
      }
      return n;
    }

    if (n.builtComponent != null) {
      return n;
    }

    var current = n.id;

    if (p.isEmpty) {
      p += current;
    } else {
      p += '/$current';
    }

    print('Generating middle page: $current');
    var middleFolder = './${config['base']}/${config['output']}/$p';
    n.builtComponent = await createMdPage(
      appId,
      config['base'],
      middleFolder,
      '${current.toLowerCase()}_preview_page_dummy.dart',
      '',
      current.capitalize(),
      p,
      pageRoute,
      n.childrenList,
    );

    n.builtComponent!.route = p;

    for (var entry in n.children.entries) {
      var f = await buildMiddlePages(
        config,
        appId,
        entry.value,
        p,
        pageRoute,
        level + 1,
      );
      if (f == null) continue;
      n.children[entry.key] = f;
    }
    return n;
  } catch (e) {
    return null;
  }
}

Future<void> generatePreview(
  String srcPath,
  String classImport,
  String previewAnnotation,
  String className,
  String prefix,
  Preview preview,
) async {
  var clazz = className.replaceAll('()', '');

  var widgetCompose = '';

  if (preview.usesDummies) {
    widgetCompose = dummyWidgetContent(className, preview);
  } else {
    widgetCompose = basicWidgetContent(className, preview);
  }

  String fileName = srcPath.split('/').last;
  String name = fileName.split('.').first;

  var content = '''
/// AUTOGENERATED FILE. DO NOT EDIT

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import '$classImport';
${preview.usesDummies ? '''import 'dummy/$name.dummy.dart';''' : ''}

$previewAnnotation
class ${clazz}Preview extends PreviewWidget {
  const ${clazz}Preview({super.key});
  
  ${!preview.usesDummies ? '''
  @override
  Widget preview(BuildContext context) => Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: $widgetCompose,
        );
  ''' : ''}
  
  ${preview.usesDummies ? '''@override
  Widget preview(BuildContext context) => ${clazz}Dummy().dummies.isEmpty
      ? Container()
      : ListView(
          children: [
            for (int i = 0; i < ${clazz}Dummy().dummies.length; i++)
              Center(
                child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 700,
                      maxWidth: 700,
                    ),
                    child:Builder(
                    builder: (context) {
                      var dummy = ${clazz}Dummy().dummies[i];
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: $widgetCompose,
                      );
                  },
                ),
              ),
            ),
          ],
        );''' : ''}
}
    ''';

  String dirPath = srcPath.replaceAll(fileName, '');
  String previewPath = '${dirPath}preview/';

  await Directory(previewPath).create(recursive: true);

  String previewFile = '$previewPath$name.$prefix.dart';
  File file = File(previewFile);
  await file.writeAsString(content);
}

String basicWidgetContent(String className, Preview preview) {
  var clazz = className.replaceAll('()', '');

  var widgetCompose = '$clazz(';

  for (dynamic element in preview.listParameters) {
    if (element is String) {
      widgetCompose += '\'$element\',';
    }
  }
  var params = preview.parameters.entries.toList();
  if (params.isNotEmpty) {
    widgetCompose += '';
    for (MapEntry<String, dynamic> entry in params) {
      if (entry.value is String) {
        if (entry.value == 'void_function_snackbar') {
          widgetCompose += '''${entry.key}: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            '${entry.key} event',
          ),
        ),
      );
    },''';
        } else if (entry.value == 'dummy_text_small') {
          widgetCompose += '''child: const DummyText(),''';
        } else {
          widgetCompose += '${entry.key}: \'${entry.value}\',';
        }
      }
    }
    widgetCompose += '';
  }

  widgetCompose += ')';

  return widgetCompose;
}

String dummyWidgetContent(String className, Preview preview) {
  var clazz = className.replaceAll('()', '');

  var widgetCompose = '$clazz(';

  /*
  for (dynamic element in preview.listParameters) {
    if (element is String) {
      widgetCompose += '\'$element\',';
    }
  }*/
  var params = preview.dummyParameters;
  if (params.isNotEmpty) {
    widgetCompose += '';
    for (String key in params) {
      if (key == 'void_function_snackbar') {
        widgetCompose += '''$key: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'callback $key',
          ),
        ),
      );
    },''';
      } else if (key == 'dummy_text_small') {
        widgetCompose += '''child: const DummyText(),''';
      } else {
        widgetCompose += '''$key: dummy.parameters['$key'],''';
      }
    }
    widgetCompose += '';
  }

  widgetCompose += ')';

  return widgetCompose;
}

Future<void> generateDummy(
  String srcPath,
  String className,
) async {
  var clazz = className.replaceAll('()', '');

  String fileName = srcPath.split('/').last;
  String name = fileName.split('.').first;
  String dirPath = srcPath.replaceAll(fileName, '');
  String previewPath = '${dirPath}preview/dummy/';

  await Directory(previewPath).create(recursive: true);

  String previewFile = '$previewPath$name.dummy.dart';
  File file = File(previewFile);

  if (await file.exists()) {
    return;
  }

  var content = '''
/// AUTOGENERATED FILE.
///
/// Use this file for modify the preview of ${clazz}Preview
///

import 'package:catalog/catalog.dart';

class ${clazz}Dummy extends PreviewDummy {
  @override
  List<Dummy> get dummies => [];
}
    ''';

  await file.writeAsString(content);
}
