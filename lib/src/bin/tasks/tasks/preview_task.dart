import 'dart:io';

import '../../preview_builder/dummy_builder.dart';
import '../../preview_builder/preview_builder.dart';
import '../../utils/configuration.dart';
import '../base/base_task.dart';

class PreviewTask extends BaseTask {
  @override
  Future<void> work(List<String> args) async {
    final base = args.isEmpty ? '' : '${args.first}/';

    var appId = loadId(base);
    var config = loadConfigFile(base);

    final prefixValue = config['prefix'] ?? 'preview';

    final dir = Directory('./$base${config['base']}');
    await dir.create(recursive: true);

    final dirOutPut = Directory('./$base${config['base']}/${config['output']}');
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
      print('preview on file: ${file.path}');
      var preview = await previewOnFile(base, config, file.path);
      var previewAnnotation = await findPreviewAnnotation(file.path);
      if (previewAnnotation == null) continue;
      var className = await findClassName(file.path);
      if (className == null) continue;
      if (preview == null) continue;

      await generatePreview(
        config,
        file.path,
        classImport,
        previewAnnotation,
        className,
        prefixValue,
        preview,
      );

      await generateDummy(
        file.path,
        className,
      );
    }
  }
}
