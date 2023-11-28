import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CatalogRunner extends StatefulWidget {
  final List<String> args;
  final Widget application;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Iterable<Locale>? supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleResolutionCallback? localeResolutionCallback;
  final ThemeData? theme;
  final Key? appKey;
  final Function()? ready;

  final GoRoute route;
  final bool enabled;

  const CatalogRunner({
    super.key,
    required this.args,
    required this.route,
    required this.application,
    this.scaffoldMessengerKey,
    this.appKey,
    this.supportedLocales,
    this.localizationsDelegates,
    this.localeResolutionCallback,
    this.ready,
    this.theme,
    this.enabled = false,
  });

  @override
  State<CatalogRunner> createState() => _CatalogRunnerState();
}

class _CatalogRunnerState extends State<CatalogRunner> {
  @override
  Widget build(BuildContext context) {
    if (!widget.args.contains('catalog') && !widget.enabled) {
      return widget.application;
    }

    if (Catalog().router == null) {
      Catalog().router = GoRouter(
        initialLocation: '/catalog',
        routes: [
          widget.route,
        ],
      );
      if (widget.ready != null) {
        widget.ready!();
      }
    }

    return MaterialApp.router(
      routerConfig: Catalog().router,
      key: widget.appKey,
      scaffoldMessengerKey: widget.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      title: 'Catalog',
      theme: widget.theme ??
          ThemeData(
            fontFamily: 'Roboto',
          ),
      supportedLocales:
          widget.supportedLocales ?? const <Locale>[Locale('en', 'US')],
      localizationsDelegates: widget.localizationsDelegates,
      localeResolutionCallback: widget.localeResolutionCallback,
    );
  }
}
