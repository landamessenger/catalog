# Catalog

> This package uses `go_router` for simplify the navigation. If you aren't using this package, you can run
> the `CatalogApp` for run it.

> This package doesn't render your widgets in IDEA, Android Studio or Visual Studio Code.

This package allows you to create a widget catalog. Every widget page of your catalog can display one or more samples of your widget.

*Where I see this catalog?* After you prepare your widgets, you must run your app and go to `/catalog`.

#### Installation

```yaml
dependencies:
  catalog: ^0.0.1                           # android   ios   linux   macos   web   windows

catalog:
  base: "lib"                                       # app src
  output: "ui/catalog"                              # catalog path -> /lib/ui/catalog/
  pageFile: "catalog_component.dart"                # catalog page file
  pageName: "CatalogComponent"                      # catalog page class
  pageRoute: "catalog"                              # catalog route -> /catalog
  runtimeConfigHolder: "assets/preview_config.json"
  suffix: "preview"                                 # file suffix for preview files -> my_widget.preview.dart
```

### Create a page for a widget

Include the `@Preview` annotation:

```dart
import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

@Preview(
  id: 'SizedContainerPreview',
  path: 'sized/container',
  description: 'Container with a max width of 700',
  parameters: {
    'child': 'dummy_text_small',
  },
)
class SizedContainer extends StatelessWidget {
  final Widget? child;

  const SizedContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 700,
      ),
      child: child,
    );
  }
}
```

### Generate the preview and dummy files

```bash
flutter pub run catalog:preview && dart format lib/*
```

```
your_widget_folder
    |
    |-- preview
    |   |
    |   |-- dummy
    |   |   |
    |   |   |-- sized_container.dummy.dart      <-- dummy created (only created if not exist)
    |   |
    |   |-- sized_container.preview.dart        <-- preview created (always regenerated)
    |
    |--sized_container.dart                     <-- widget file
```

> Notice the suffix `preview` is defined in `pubspec.yaml`

### Generate your catalog

```bash
flutter pub run catalog:build && dart format lib/*
```

```
   lib
    |
    |-- ui
        |
        |-- catalog
            |
            |-- catalog_component.dart                  <-- catalog created
            |
            |-- sized
                |
                |-- container
                    |
                    |-- sized_container.preview.dart    <-- widget page created

```

> Notice the suffix `preview` is defined in `pubspec.yaml`

> Notice the catalog creation path is defined in `pubspec.yaml` (in this sample /lib/ui/catalog/)

> Notice the catalog-page creation path is defined in `@Preview` and `pubspec.yaml` (in this sample /catalog/sized/container)


### Include the routes

```dart
final router = GoRouter(
  routes: [
    // ... other routes
    
    // add the catalog route in debug mode (can be run in release, but it is not recommended)
    if (kDebugMode) CatalogComponent.route,
  ],
);
```

> Notice `CatalogComponent` class name is defined in `pubspec.yaml`

## Run 🚀

Run you app in debug mode. Then go to `/catalog`.
