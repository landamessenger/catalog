import 'tasks/main_task.dart';
import 'utils/configuration.dart';

const kDebugMode = true;

void main(List<String> arguments) async {
  var dependencies = loadDependenciesFile();
  print(introMessage(dependencies['catalog'].toString()));
  await MainTask().work();
}
