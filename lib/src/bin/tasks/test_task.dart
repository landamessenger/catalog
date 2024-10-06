import 'package:catalog/src/bin/utils/messages.dart';

import 'base/base_task.dart';
import 'tasks/format_task.dart';
import 'tasks/test_task.dart' as test;

class TestTask extends BaseTask {
  final tasks = [
    test.TestTask(),
    FormatTask(),
  ];

  @override
  Future<void> work(List<String> args) async {
    for (BaseTask task in tasks) {
      try {
        print('\n - Running ${task.runtimeType.toString()} \n');
        await task.work(args);
      } catch (e) {
        print(e);
      }
    }
    print(commonMessage('🧪 Tests generated'));
  }
}
