import 'package:catalog/src/base/serial.dart';
import 'package:catalog/src/builders/catalog/built_component.dart';

class ComponentNode extends Serial<ComponentNode> {
  String id = '';
  String route = '';

  String get routePath {
    if (!route.contains('/')) return route;
    var parts = route.split('/');
    return parts.last;
  }

  Map<String, BuiltComponent> builtComponents = <String, BuiltComponent>{};

  Map<String, ComponentNode> children = <String, ComponentNode>{};

  List<BuiltComponent> get builtComponentList =>
      builtComponents.values.toList();

  List<ComponentNode> get childrenList => children.values.toList();

  ComponentNode({
    this.id = '',
    this.route = '',
  });

  @override
  ComponentNode fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    route = json['route'] ?? '';
    builtComponents =
        Serial.fromComplexMap<BuiltComponent>(json['builtComponents'] ?? {});
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
        'builtComponents':
            builtComponents.isEmpty ? {} : Serial.toMap(builtComponents),
        'children': children.isEmpty ? {} : Serial.toMap(children),
      };

  String get routerBuilder {
    if (route == '/') {
      return '''
       GoRoute(
          path: CatalogComponent.routeName,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const CatalogComponent(),
          ),
          routes: [
            ${childrenList.map((e) => e.routerBuilder).toList().join(',')}
          ],
      )
''';
    }
    return '''
        GoRoute(
          path: '$routePath',
          redirect: (context, state) {
            if (state.fullPath != state.matchedLocation) return null;
            return CatalogComponent.routeName;
          },
          routes: [
             ${builtComponentList.map((e) {
              return '''
        
        GoRoute(
          path: ${e.clazzName}.routeName,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ${e.clazzName}(),
          ),
        )
        
         ''';
            }).toList().join(',')}
            ${builtComponentList.isNotEmpty ? ',' : ''}
            ${childrenList.map((e) => e.routerBuilder).toList().join(',')}
          ],
        )
  ''';
  }

  String get routerBuilderB {
    return '''
  ${builtComponentList.map((e) {
              return '''
        
        GoRoute(
          path: ${e.clazzName}.routeName,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ${e.clazzName}(),
          ),
        )
        
         ''';
            }).toList().join(',')}
      ${childrenList.map((e) => e.routerBuilder).toList().join(',')}
  ''';
  }

  String get imports {
    String value = '''
${childrenList.map((e) => e.imports).toList().join('')}\n
${builtComponentList.map((e) => 'import \'${e.package}\';').toList().join('')}\n
    ''';
    return value;
  }
}
