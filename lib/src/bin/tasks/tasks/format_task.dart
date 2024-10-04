import 'dart:io';

import '../base/base_task.dart';

class FormatTask extends BaseTask {
  @override
  Future<void> work(List<String> args) async {
    var resultFix = await Process.run(
      'dart',
      ['fix', '--apply'],
      workingDirectory: Directory.current.path,
    );
    stdout.write(resultFix.stdout);
    stderr.write(resultFix.stderr);

    var result = await Process.run(
      'dart',
      ['format', 'lib/'],
      workingDirectory: Directory.current.path,
    );
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  }
}
