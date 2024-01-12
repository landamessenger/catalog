import 'package:catalog/catalog.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:flutter/material.dart';

import 'catalog/catalog_component.dart';
import 'widgets/fab_widget.dart';

void main() {
  /**
   * CatalogRunner will run your app as normal
   * and will open the catalog if:
   *
   * - [CatalogRunner.enabled] is TRUE
   * - Run the project with: flutter run -d ANY_DEVICE --dart-define catalog=true
   */
  runApp(
    CatalogRunner(
      enabled: false,
      application: const MyApp(),
      route: CatalogComponent.route,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BodyWidget(
        infoText: 'You have pushed the button this many times:',
        counter: _counter,
      ),
      floatingActionButton: FabWidget(
        incrementCounter: _incrementCounter,
      ),
    );
  }
}
