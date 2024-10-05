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

    var resultFormatLib = await Process.run(
      'dart',
      ['format', 'lib/'],
      workingDirectory: Directory.current.path,
    );
    stdout.write(resultFormatLib.stdout);
    stderr.write(resultFormatLib.stderr);

    var resultFormatTest = await Process.run(
      'dart',
      ['format', 'test/'],
      workingDirectory: Directory.current.path,
    );
    stdout.write(resultFormatTest.stdout);
    stderr.write(resultFormatTest.stderr);

    var resultFormatInstrumentedTest = await Process.run(
      'dart',
      ['format', 'integration_test/'],
      workingDirectory: Directory.current.path,
    );
    stdout.write(resultFormatInstrumentedTest.stdout);
    stderr.write(resultFormatInstrumentedTest.stderr);
  }
}
