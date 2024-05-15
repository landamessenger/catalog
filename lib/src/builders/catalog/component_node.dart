import 'package:catalog/src/base/serial.dart';
import 'package:catalog/src/builders/catalog/built_component.dart';

class ComponentNode extends Serial<ComponentNode> {
  String id = '';
  String route = '';
  BuiltComponent? builtComponent;
  Map<String, ComponentNode> children = <String, ComponentNode>{};

  List<ComponentNode> get childrenList => children.values.toList();

  ComponentNode({
    this.id = '',
    this.route = '',
    this.builtComponent,
  });

  @override
  ComponentNode fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    route = json['route'] ?? '';
    if (json['builtComponent'] != null) {
      builtComponent = BuiltComponent().fromJson(json['builtComponent'] ?? {});
    }
    children = Serial.fromComplexMap<ComponentNode>(json['children'] ?? {});
    return this;
  }

  @override
  String getId() => id;

  @override
  ComponentNode instance() => ComponentNode();

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'route': route,
        'builtComponent': builtComponent?.toJson(),
        'children': children.isEmpty ? {} : Serial.toMap(children),
      };

  String get routerBuilder => '''
  GoRoute(
      path: ${builtComponent?.clazzName}.routeName,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const ${builtComponent?.clazzName}(),
      ),
      routes: [${childrenList.map((e) => e.routerBuilder).toList().join(',')}],
    )
  ''';

  String get imports {
    String value = '';
    if (builtComponent == null) {
      return value;
    }
    if (route == "/") {
      value += '''${childrenList.map((e) => e.imports).toList().join('')}
''';
    } else {
      if (childrenList.isEmpty) {
        value += '''import '${builtComponent!.package}';
''';
      } else {
        value += '''import '${builtComponent!.package}';
${childrenList.map((e) => e.imports).toList().join('')}
''';
      }
    }
    return value;
  }
}
