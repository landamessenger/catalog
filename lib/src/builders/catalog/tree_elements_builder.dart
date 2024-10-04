import 'package:catalog/src/builders/catalog/component_node.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildTreeWidget(
  BuildContext context,
  String basePath,
  ComponentNode node,
  int level,
) {
  var padding = 32.0;
  return Stack(
    children: [
      Padding(
        padding: EdgeInsets.only(left: level == 0 ? 0 : padding),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            key: PageStorageKey<String>(node.route),
            initiallyExpanded: true,
            leading: const Icon(Icons.folder),
            iconColor: Colors.teal,
            collapsedIconColor: Colors.grey,
            title: Text(node.id.isNotEmpty ? node.id : 'Root'),
            children: <Widget>[
              ...node.builtComponentList.map(
                (builtComponent) => Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: ListTile(
                    title: Text(builtComponent.name),
                    leading: const Icon(
                      Icons.insert_drive_file,
                    ),
                    onTap: () {
                      final id = builtComponent.preview?.id;
                      if (id != null) {
                        context.go('$basePath/${builtComponent.route}/$id');
                      }
                    },
                  ),
                ),
              ),
              ...node.childrenList.map(
                (childNode) => buildTreeWidget(
                  context,
                  basePath,
                  childNode,
                  level + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
