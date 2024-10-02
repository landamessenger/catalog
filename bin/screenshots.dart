import 'package:catalog/src/bin/tasks/tasks/server_task.dart';
import 'package:catalog/src/bin/utils/configuration.dart';

void main(List<String> arguments) async {
  var dependencies = loadDependenciesFile('');
  print(introMessage(dependencies['catalog'].toString()));
  await ServerTask().work([]);
}
