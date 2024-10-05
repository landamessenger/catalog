import 'base/base_task.dart';
import 'tasks/catalog_task.dart';
import 'tasks/format_task.dart';
import 'tasks/preview_task.dart';
import 'tasks/test_task.dart';

class MainTask extends BaseTask {
  final tasks = [
    PreviewTask(),
    TestTask(),
    CatalogTask(),
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
    print('\n Previews, tests and catalog generated \n');
  }
}
