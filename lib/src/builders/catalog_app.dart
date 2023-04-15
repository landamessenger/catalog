import 'package:catalog/catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CatalogApp extends StatefulWidget {
  final ThemeData? themeData;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale>? supportedLocales;

  const CatalogApp({
    Key? key,
    this.themeData,
    this.localizationsDelegates,
    this.localeResolutionCallback,
    this.supportedLocales,
  }) : super(key: key);

  @override
  CatalogAppState createState() => CatalogAppState();
}

class CatalogAppState extends State<CatalogApp> {
  final global = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/catalog',
        routes: Catalog().routes,
      ),
      key: Catalog().global,
      scaffoldMessengerKey: Catalog().key,
      debugShowCheckedModeBanner: kDebugMode,
      showPerformanceOverlay: false,
      title: 'Catalog',
      theme: widget.themeData ??
          ThemeData(
            fontFamily: 'Roboto',
          ),
      supportedLocales: widget.supportedLocales ?? [],
      localizationsDelegates: widget.localizationsDelegates,
      localeResolutionCallback: widget.localeResolutionCallback,
    );
  }
}
