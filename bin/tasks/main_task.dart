import 'base/base_task.dart';
import 'tasks/catalog_task.dart';
import 'tasks/format_task.dart';
import 'tasks/preview_task.dart';

class MainTask extends BaseTask {
  final tasks = [
    PreviewTask(),
    CatalogTask(),
    FormatTask(),
  ];

  @override
  Future<void> work() async {
    for (BaseTask task in tasks) {
      try {
        print('\n - Running ${task.runtimeType.toString()} \n');
        await task.work();
      } catch (e) {
        print(e);
      }
    }
  }
}
