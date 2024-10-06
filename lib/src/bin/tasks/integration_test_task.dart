import 'package:catalog/src/bin/utils/messages.dart';

import 'base/base_task.dart';
import 'tasks/format_task.dart';
import 'tasks/integration_test_task.dart' as test;

class IntegrationTestTask extends BaseTask {
  final tasks = [
    test.IntegrationTestTask(),
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
    print(commonMessage('🧪📱 Integration tests generated'));
  }
}
