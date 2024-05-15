import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:stringcare/stringcare.dart';

import 'catalog/catalog_component.dart';
import 'r.dart';
import 'widgets/main_screen.dart';

void main() {
  /**
   * Available languages.
   */
  Stringcare().locales = [
    const Locale('en'),
    const Locale('es'),
  ];

  /**
   * If you don't use [go_router] and launch [CatalogRunner] you need to provide
   * any kind of context.
   */
  Catalog().runnerRouterSet = (router) => Stringcare().router = router;

  /**
   * In order to capture screenshots of your app in different languages you
   * have to change the language programmatically.
   */
  Catalog().beforeCapture = Stringcare().refreshWithLocale;

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
      supportedLocales: Stringcare().locales,
      localizationsDelegates: Stringcare().delegates,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends ScState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Stringcare().navigatorKey,
      title: 'Flutter Demo',
      supportedLocales: Stringcare().locales,
      localizationsDelegates: Stringcare().delegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
    return MainScreen(
      title: R.strings.title_app.string(),
      counter: _counter,
      infoText: R.strings.info_text.string(),
      incrementCounter: _incrementCounter,
    );
  }
}
