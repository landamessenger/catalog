import 'dart:io';

import 'preview_builder/dummy_builder.dart';
import 'preview_builder/preview_builder.dart';
import 'utils/configuration.dart';

const kDebugMode = true;

void main(List<String> arguments) async {
  var dependencies = loadDependenciesFile();
  if (kDebugMode) {
    print(introMessage(dependencies['catalog'].toString()));
    print('Building Catalog previews');
  }

  var appId = loadId();
  var config = loadConfigFile();

  final prefixValue = config['prefix'] ?? 'preview';

  final dir = Directory('./${config['base']}');
  await dir.create(recursive: true);

  final dirOutPut = Directory('./${config['base']}/${config['output']}');
  await dirOutPut.create(recursive: true);

  final List<FileSystemEntity> entities =
      await dir.list(recursive: true).toList();

  final files = <FileSystemEntity>[];

  for (FileSystemEntity fileSystemEntity in entities) {
    try {
      if (fileSystemEntity is Directory) continue;
      if (fileSystemEntity.path.endsWith('.DS_Store')) continue;
      final File file = File(fileSystemEntity.path);
      if (file.path.contains('.$prefixValue.')) continue;
      final content = await file.readAsString();
      if (content.contains('@Preview(')) {
        files.add(fileSystemEntity);
      }
    } catch (e) {
      print(e);
    }
  }

  for (FileSystemEntity fileSystemEntity in files) {
    final File file = File(fileSystemEntity.path);
    var p = file.path.split(config['base'])[1];
    var classImport = 'package:$appId$p';
    var preview = await previewOnFile(config, file.path);
    var previewAnnotation = await findPreviewAnnotation(file.path);
    if (previewAnnotation == null) continue;
    var className = await findClassName(file.path);
    if (className == null) continue;
    if (preview == null) continue;

    await generatePreview(
      file.path,
      classImport,
      previewAnnotation,
      className,
      prefixValue,
      preview,
    );

    if (preview.usesDummies) {
      await generateDummy(
        file.path,
        className,
      );
    }
  }
}
