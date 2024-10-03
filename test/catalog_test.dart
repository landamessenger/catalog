import 'package:catalog/src/bin/tasks/main_task.dart';
import 'package:catalog/src/bin/utils/configuration.dart';
import 'package:catalog/src/catalog_runner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('Basic dummy test', () {
    final runner = CatalogRunner(
      application: Container(),
      route: GoRoute(
        path: '/catalog',
        builder: (context, state) => Container()
      ),
    );
    expect(runner.enabled, false);
  });

  test('Test Preview task (preview + format)', () async {
    final exampleFolder = 'example';
    var dependencies = loadDependenciesFile('$exampleFolder/');
    print(introMessage(dependencies['catalog'].toString()));
    await MainTask().work([exampleFolder]);
    assert(true);
  });

  test('Test Main task (preview + catalog + format)', () async {
    final exampleFolder = 'example';
    var dependencies = loadDependenciesFile('$exampleFolder/');
    print(introMessage(dependencies['catalog'].toString()));
    await MainTask().work([exampleFolder]);
    assert(true);
  });
}
