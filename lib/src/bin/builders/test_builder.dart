import 'dart:io';
import 'dart:math';

import 'package:catalog/src/bin/utils/test_builder_info.dart';
import 'package:catalog/src/extensions/string_ext.dart';

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
  importParts.add(config['pageRoute']);
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
            // prepare the context
            await tester.setupTestContext();
            
            // prepare the widget
            final dummy = ${clazz}Dummy().dummies.first;
            final widget = build$clazz(dummy);
            await tester.test(widget);

            // check
            expect(find.text('cómo están los máquinas'), findsNothing);
          },
        );

        testWidgets(
          'Other lorem text not found',
          (tester) async {
            // prepare the context
            await tester.setupTestContext();
            
            // prepare the widget
            final dummy = ${clazz}Dummy().dummies.first;
            final widget = build$clazz(dummy);
            await tester.test(widget);

            // check
            expect(find.text('lo primero de todo'), findsNothing);
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
  importParts.add(config['pageRoute']);
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

class ${clazz}IntegrationTest {
  void main() {
    group(
      '$clazz - IntegrationTest Tests',
      () {
        testWidgets(
          'Lorem text not found',
          (tester) async {
            // prepare the context
            await tester.setupIntegrationTestContext();
            
            // prepare the widget
            final dummy = ${clazz}Dummy().dummies.first;
            final widget = build$clazz(dummy);
            await tester.test(widget);

            // check
            expect(find.text('cómo están los máquinas'), findsNothing);
          },
        );

        testWidgets(
          'Other lorem text not found',
          (tester) async {
            // prepare the context
            await tester.setupIntegrationTestContext();
            
            // prepare the widget
            final dummy = ${clazz}Dummy().dummies.first;
            final widget = build$clazz(dummy);
            await tester.test(widget);

            // check
            expect(find.text('lo primero de todo'), findsNothing);
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
  String modelImport,
  String modelImplementation,
) async {
  File file = File('./${basePath}test/catalog_widget_test.dart');

  print('🧪 Updating catalog test collector (${file.path})');

  if (modelImport.isNotEmpty && modelImplementation.isNotEmpty) {
    print('🧪📦 Object dependency detected. Including ($modelImport)');
  }

  var content = '''
/// AUTOGENERATED FILE. DO NOT EDIT

${modelImport.isNotEmpty ? 'import \'$modelImport\';' : ''}
${tests.map((t) {
    return 'import \'${t.import}\' as ${t.alias};';
  }).join('\n')}

void main() {
 
  ${modelImplementation.isNotEmpty ? '$modelImplementation;' : ''}

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
  String modelImport,
  String modelImplementation,
) async {
  String testPath = './${basePath}integration_test/';

  await Directory(testPath).create(recursive: true);

  File file = File(
      './${basePath}integration_test/catalog_widget_integration_test.dart');

  print('🧪 Updating catalog integration test collector (${file.path})');

  if (modelImport.isNotEmpty && modelImplementation.isNotEmpty) {
    print('🧪📦 Object dependency detected. Including ($modelImport)');
  }

  var content = '''
/// AUTOGENERATED FILE. DO NOT EDIT

/// Launch on Android or iOS as usual.
/// Launch on Web with:
///
/// chromedriver --port=4444
/// flutter drive --driver=test_driver/integration_test.dart --target=integration_test/catalog_widget_integration_test.dart -d chrome

import 'package:integration_test/integration_test.dart';

${modelImport.isNotEmpty ? 'import \'$modelImport\';' : ''}

${tests.map((t) {
    return 'import \'${t.import}\' as ${t.alias};';
  }).join('\n')}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  ${modelImplementation.isNotEmpty ? '$modelImplementation;' : ''}

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

String getObjectImport(String appId, Map<String, dynamic> config) {
  if (config.isEmpty) return '';
  return 'package:$appId/${config['outputFolder']}/${config['modelsFile']}';
}

String getObjectImplementation(Map<String, dynamic> config) {
  if (config.isEmpty) return '';
  var file = config['modelsFile'] as String;
  var n = file.split('.').first;
  var clazz = n.toClassName();
  return '$clazz().instancesForLoad()';
}
