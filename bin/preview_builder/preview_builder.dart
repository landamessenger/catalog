import 'dart:io';

import 'package:catalog/src/annotations/preview.dart';

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
class ${clazz}Preview extends ParentPreviewWidget {
  const ${clazz}Preview({super.key});
  
  ${!preview.usesDummies ? '''
  @override
  Widget preview(BuildContext context) =>  Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ${(preview.parameters.containsKey('child') || preview.parameters.isEmpty) ? 'const' : ''} $widgetCompose,
        );
  ''' : ''}
  
  ${preview.usesDummies ? '''
  
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
              ${dummyWidgetBuilder(clazz, widgetCompose)}
          ],
        )
      ],
    );
  }
  
  ''' : ''}
}
    ''';

  String dirPath = srcPath.replaceAll(fileName, '');
  String previewPath = '${dirPath}preview/';

  await Directory(previewPath).create(recursive: true);

  String previewFile = '$previewPath$name.$prefix.dart';

  print('🩻 Generating preview for $clazz - ${clazz}Preview ($previewFile)');

  File file = File(previewFile);
  await file.writeAsString(content);
}

String dummyWidgetBuilder(String clazz, String widgetCompose) {
  return '''
  PreviewBoundary(
    widgetKey: GlobalKey(),
    dummyBuilder: () => ${clazz}Dummy().dummies[i],
    builder: (BuildContext context, Dummy dummy) {
      return $widgetCompose;
    },
  ),
  ''';
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
          widgetCompose += '''child: DummyText(),''';
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
