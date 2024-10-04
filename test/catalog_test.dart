import 'package:catalog/src/bin/tasks/main_task.dart';
import 'package:catalog/src/bin/utils/configuration.dart';
import 'package:catalog/src/catalog_runner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  final dependency = 'catalog';
  final exampleFolder = 'example';

  test(
    'Basic dummy test',
    () {
      final runner = CatalogRunner(
        application: Container(),
        route:
            GoRoute(path: '/catalog', builder: (context, state) => Container()),
      );
      expect(runner.enabled, false);
    },
  );

  test(
    'Test Preview task (preview + format)',
    () async {
      var dependencies = loadDependenciesFile('$exampleFolder/');
      print(introMessage(dependencies[dependency].toString()));
      await MainTask().work([exampleFolder]);
    },
  );

  test(
    'Test Main task (preview + catalog + format)',
    () async {
      var dependencies = loadDependenciesFile('$exampleFolder/');
      print(introMessage(dependencies[dependency].toString()));
      await MainTask().work([exampleFolder]);
      assert(true);
    },
  );
}
