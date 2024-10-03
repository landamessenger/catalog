import 'dart:convert';

import 'package:catalog/src/base/serial.dart';
import 'package:catalog/src/builders/catalog/built_component.dart';

class ComponentNode extends Serial<ComponentNode> {
  String id = '';
  String route = '';
  BuiltComponent? builtComponent;
  Map<String, BuiltComponent> builtComponents = <String, BuiltComponent>{};
  Map<String, ComponentNode> children = <String, ComponentNode>{};

  List<BuiltComponent> get builtComponentList =>
      builtComponents.values.toList();

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
        'builtComponent': builtComponent?.toJson(),
        'builtComponents':
            builtComponents.isEmpty ? {} : Serial.toMap(builtComponents),
        'children': children.isEmpty ? {} : Serial.toMap(children),
      };

  String get routerBuilder {
    for (var o in childrenList) {
      print('routes builder: ${jsonEncode(o.toJson())}');
    }
    return '''
  GoRoute(
      path: ${builtComponent?.clazzName}.routeName,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const ${builtComponent?.clazzName}(),
      ),
      routes: [
      ${builtComponentList.map((e) {
              return '''
        
        GoRoute(
          path: ${e.clazzName}.routeName,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ${e.clazzName}(),
          ),
        ),
        
         ''';
            }).toList().join(',')}
      ${childrenList.map((e) => e.routerBuilder).toList().join(',')}
      
      ],
    )
  ''';
  }

  String get imports {
    String value = '';
    if (builtComponent == null) {
      return value;
    }
    if (route == "/") {
      value += '''${childrenList.map((e) => e.imports).toList().join('')}\n''';
    } else {
      if (childrenList.isEmpty) {
        print('adding import (single): ${builtComponent!.package}');
        value += '''import '${builtComponent!.package}';\n''';
      } else {
        value += '''import '${builtComponent!.package}';
${childrenList.map((e) {
                  print('adding import: ${e.imports}');
                  return e.imports;
                }).toList().join('')}\n
                
${builtComponentList.map((e) {
                  print('adding import: ${e.package}');
                  return 'import \'${e.package}\';';
                }).toList().join('')}\n''';
      }
    }
    return value;
  }
}
