import 'dart:io';

import 'package:catalog/src/bin/builders/common_builder.dart';
import 'package:catalog/src/bin/builders/test_builder.dart';
import 'package:catalog/src/bin/tasks/base/base_task.dart';
import 'package:catalog/src/bin/utils/configuration.dart';
import 'package:catalog/src/bin/utils/test_builder_info.dart';

class TestTask extends BaseTask {
  @override
  Future<void> work(List<String> args) async {
    final base = args.isEmpty ? '' : '${args.first}/';

    var appId = loadId(base);
    var configCatalog = loadCatalogConfigFile(base);
    var configObject = loadObjectConfigFile(base);

    String objectImport = getObjectImport(appId, configObject);
    String objectImplementation = getObjectImplementation(configObject);

    final prefixValue = configCatalog['prefix'] ?? 'preview';

    final dir = Directory('./$base${configCatalog['base']}');
    await dir.create(recursive: true);

    final dirOutPut =
        Directory('./$base${configCatalog['base']}/${configCatalog['output']}');
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

    final test = <TestBuilderInfo>[];

    for (FileSystemEntity fileSystemEntity in files) {
      final File file = File(fileSystemEntity.path);
      var p = file.path.split(configCatalog['base'])[1];
      var classImport = 'package:$appId$p';
      var preview = await previewOnFile(base, configCatalog, file.path);
      var previewAnnotation = await findPreviewAnnotation(file.path);
      if (previewAnnotation == null) continue;
      var className = await findClassName(file.path);
      if (className == null) continue;
      if (preview == null) continue;

      final testFile = await generateTest(
        configCatalog,
        file.path,
        className,
        classImport,
        prefixValue,
      );

      test.add(testFile);
    }

    await generateMainTest(
      base,
      test,
      objectImport,
      objectImplementation,
    );
  }
}
