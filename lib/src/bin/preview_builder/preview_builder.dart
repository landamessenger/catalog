import 'dart:io';
import 'dart:math';

import 'package:catalog/src/annotations/internal_preview.dart';
import 'package:catalog/src/bin/utils/test_builder_info.dart';

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

Future<void> generatePreview(
  dynamic config,
  String srcPath,
  String classImport,
  String previewAnnotation,
  String className,
  String prefix,
  InternalPreview preview,
) async {
  var clazz = className.replaceAll('()', '');

  var widgetCompose = dummyWidgetContent(className, preview);

  String fileName = srcPath.split('/').last;
  String name = fileName.split('.').first;

  var content = '''
/// AUTOGENERATED FILE. DO NOT EDIT

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import '$classImport';
import '../dummy/$name.dummy.dart';

$previewAnnotation
class ${clazz}Preview extends ParentPreviewWidget {
  
  @override
  String get title => '$name';
  
  @override
  String get basePath => '/${config['pageRoute']}';
  
  const ${clazz}Preview({super.key});
    
  @override
  Widget preview(BuildContext context) {
    Catalog().widgetBasicPreviewMap.clear();
    Catalog().widgetDevicePreviewMap.clear();

    if (${clazz}Dummy().dummies.isEmpty) {
      return Container();
    }

    final deviceScreenshotsAvailable =
        ${clazz}Dummy().deviceScreenshotsAvailable;
    final screenshotsAvailable = ${clazz}Dummy().screenshotsAvailable;

    int basicScreenshots = screenshotsAvailable - deviceScreenshotsAvailable;

    return ListView(
      children: [
        Column(
          children: [
            if (basicScreenshots > 0)
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                '\$basicScreenshots basic screenshots available',
                              ),
                            ),
                          ),
                          const IconButton(
                            onPressed: processBasicScreenshots,
                            icon: Icon(
                              Icons.screenshot,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (deviceScreenshotsAvailable > 0)
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                '\$deviceScreenshotsAvailable device screenshots available',
                              ),
                            ),
                          ),
                          const IconButton(
                            onPressed: processDeviceScreenshots,
                            icon: Icon(
                              Icons.screenshot,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            for (int i = 0; i < ${clazz}Dummy().dummies.length; i++)
              ${dummyWidgetBuilder(clazz)}
          ],
        )
      ],
    );
  }
  
  
}

$clazz build$clazz(Dummy dummy) {
  return $widgetCompose;
}
    ''';

  String dirPath = srcPath.replaceAll(fileName, '');
  String previewPath = '${dirPath}catalog/preview/';

  await Directory(previewPath).create(recursive: true);

  String previewFile = '$previewPath$name.$prefix.dart';

  print('🩻 Generating preview for $clazz - ${clazz}Preview ($previewFile)');

  File file = File(previewFile);
  await file.writeAsString(content);
}

Future<TestBuilderInfo> generateTest(
  dynamic config,
  String srcPath,
  String className,
  String classImport,
  String prefix,
) async {
  var clazz = className.replaceAll('()', '');

  String fileName = srcPath.split('/').last;
  String name = fileName.split('.').first;
  String dirPath = srcPath.replaceAll(fileName, '');
  String testPath = '${dirPath}catalog/test/';

  await Directory(testPath).create(recursive: true);

  String testFile = '$testPath${name}_test.dart';
  File file = File(testFile);

  var importParts = classImport.split('/');
  importParts.removeAt(importParts.length - 1);
  importParts.add(config['output']);
  importParts.add('test');
  importParts.add('${name}_test.dart');

  if (await file.exists()) {
    print(
        '🧪 👌 Test file already exist for $clazz - ${clazz}Test ($testFile)');
    return TestBuilderInfo(
      alias: buildTestAlias(4),
      clazzName: '${clazz}Test',
      import: importParts.join('/'),
    );
  }

  print('🧪 Generating test for $clazz - ${clazz}Test ($testFile)');

  var content = '''
/// AUTOGENERATED FILE.
///
/// Use this file to test the widget $clazz
///

import 'package:catalog/catalog.dart';

import '../dummy/$name.dummy.dart';
import '../preview/$name.$prefix.dart';

class ${clazz}Test {
  void main() {
    group(
      '$clazz - Tests',
      () {
        testWidgets(
          'Lorem text not found',
          (tester) async {
            final dummy = ${clazz}Dummy().dummies.first;
            final widget = build$clazz(dummy);
            await tester.test(widget);

            expect(find.text('lorem ipsu'), findsNothing);
          },
        );

        testWidgets(
          'Other lorem text not found',
          (tester) async {
            final dummy = ${clazz}Dummy().dummies.first;
            final widget = build$clazz(dummy);
            await tester.test(widget);

            expect(find.text('ipsu lorem'), findsNothing);
          },
        );
      },
    );
  }
}

    ''';

  await file.writeAsString(content);

  return TestBuilderInfo(
    alias: buildTestAlias(4),
    clazzName: '${clazz}Test',
    import: importParts.join('/'),
  );
}

Future<TestBuilderInfo> generateIntegrationTest(
  dynamic config,
  String srcPath,
  String className,
  String classImport,
  String prefix,
) async {
  var clazz = className.replaceAll('()', '');

  String fileName = srcPath.split('/').last;
  String name = fileName.split('.').first;
  String dirPath = srcPath.replaceAll(fileName, '');
  String testPath = '${dirPath}catalog/integration_test/';

  await Directory(testPath).create(recursive: true);

  String testFile = '$testPath${name}_integration_test.dart';
  File file = File(testFile);

  var importParts = classImport.split('/');
  importParts.removeAt(importParts.length - 1);
  importParts.add(config['output']);
  importParts.add('integration_test');
  importParts.add('${name}_integration_test.dart');

  if (await file.exists()) {
    print(
        '🧪 👌 Test file already exist for $clazz - ${clazz}IntegrationTest ($testFile)');
    return TestBuilderInfo(
      alias: buildTestAlias(4),
      clazzName: '${clazz}IntegrationTest',
      import: importParts.join('/'),
    );
  }

  print('🧪 Generating test for $clazz - ${clazz}Test ($testFile)');

  var content = '''
/// AUTOGENERATED FILE.
///
/// Use this file to test the widget $clazz
///

import 'package:catalog/catalog.dart';

import '../dummy/$name.dummy.dart';
import '../preview/$name.$prefix.dart';

class ${clazz}IntegrationTestTest {
  void main() {
    group(
      '$clazz - IntegrationTest Tests',
      () {
        testWidgets(
          'Lorem text not found',
          (tester) async {
            final dummy = ${clazz}Dummy().dummies.first;
            final widget = build$clazz(dummy);
            await tester.test(widget);

            expect(find.text('lorem ipsu'), findsNothing);
          },
        );

        testWidgets(
          'Other lorem text not found',
          (tester) async {
            final dummy = ${clazz}Dummy().dummies.first;
            final widget = build$clazz(dummy);
            await tester.test(widget);

            expect(find.text('ipsu lorem'), findsNothing);
          },
        );
      },
    );
  }
}

    ''';

  await file.writeAsString(content);

  return TestBuilderInfo(
    alias: buildTestAlias(4),
    clazzName: '${clazz}IntegrationTest',
    import: importParts.join('/'),
  );
}

Future<void> generateMainTest(
  String basePath,
  List<TestBuilderInfo> tests,
) async {
  File file = File('./${basePath}test/catalog_widget_test.dart');

  print('🧪 Updating catalog test collector (${file.path})');

  var content = '''
/// AUTOGENERATED FILE. DO NOT EDIT

${tests.map((t) {
    return 'import \'${t.import}\' as ${t.alias};';
  }).join('\n')}

void main() {
  ${tests.map((t) {
    return '${t.alias}.${t.clazzName}().main();';
  }).join('\n')}
}

    ''';

  await file.writeAsString(content);
}

Future<void> generateMainIntegrationTest(
  String basePath,
  List<TestBuilderInfo> tests,
) async {

  String testPath = './${basePath}integration_test/';

  await Directory(testPath).create(recursive: true);


  File file = File('./${basePath}integration_test/catalog_widget_integration_test.dart');

  print('🧪 Updating catalog integration test collector (${file.path})');

  var content = '''
/// AUTOGENERATED FILE. DO NOT EDIT

${tests.map((t) {
    return 'import \'${t.import}\' as ${t.alias};';
  }).join('\n')}

void main() {
  ${tests.map((t) {
    return '${t.alias}.${t.clazzName}().main();';
  }).join('\n')}
}

    ''';

  await file.writeAsString(content);
}

String buildTestAlias(int size) {
  const chars = 'abcdefghijklmnopqrstuvwxyz';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
      size, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

String dummyWidgetBuilder(String clazz) {
  return '''
  PreviewBoundary(
    widgetKey: GlobalKey(),
    dummyBuilder: () => ${clazz}Dummy().dummies[i],
    builder: (BuildContext context, Dummy dummy) {
      return build$clazz(dummy);
    },
  ),
  ''';
}

String dummyWidgetContent(String className, InternalPreview preview) {
  var clazz = className.replaceAll('()', '');

  var widgetCompose = '$clazz(';

  var params = preview.parameters;
  if (params.isNotEmpty) {
    widgetCompose += '';
    for (String key in params) {
      widgetCompose += '''$key: dummy.parameters['$key'],''';
    }
    widgetCompose += '';
  }

  widgetCompose += ')';

  return widgetCompose;
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
