import 'base/base_task.dart';
import 'tasks/format_task.dart';
import 'tasks/preview_task.dart' as preview;

class PreviewTask extends BaseTask {
  final tasks = [
    preview.PreviewTask(),
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
    print('\n Previews generated \n');
  }
}
