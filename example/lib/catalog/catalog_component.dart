/// AUTOGENERATED FILE. DO NOT EDIT

import 'package:flutter/material.dart';
import 'package:catalog/catalog.dart';
import 'package:go_router/go_router.dart';
import 'package:example/catalog/widgets/widgets_preview_page_dummy.dart';
import 'package:example/catalog/widgets/body_widget/body_widget.dart';
import 'package:example/catalog/widgets/fab_widget/fab_widget.dart';
import 'package:example/catalog/widgets/counter_widget/counter_widget.dart';

class CatalogComponent extends StatefulWidget {
  static String routeName = '/catalog';
  static GoRoute route = GoRoute(
    path: CatalogComponent.routeName,
    pageBuilder: (context, state) => NoTransitionPage(
      key: state.pageKey,
      child: const CatalogComponent(),
    ),
    routes: [
      GoRoute(
        path: WidgetsPreviewPageDummy.routeName,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const WidgetsPreviewPageDummy(),
        ),
        routes: [
          GoRoute(
            path: BodyWidgetPreviewPreviewPageDummy.routeName,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const BodyWidgetPreviewPreviewPageDummy(),
            ),
            routes: const [],
          ),
          GoRoute(
            path: FabWidgetPreviewPreviewPageDummy.routeName,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const FabWidgetPreviewPreviewPageDummy(),
            ),
            routes: const [],
          ),
          GoRoute(
            path: CounterWidgetPreviewPreviewPageDummy.routeName,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CounterWidgetPreviewPreviewPageDummy(),
            ),
            routes: const [],
          )
        ],
      )
    ],
  );
  const CatalogComponent({super.key});

  @override
  CatalogComponentState createState() => CatalogComponentState();
}

class CatalogComponentState extends State<CatalogComponent> {
  TreeController<ComponentNode>? treeController;

  @override
  Widget build(BuildContext context) {
    return PreviewScaffold(
      onBackPressed: Catalog().onBackPressed,
      child: FutureBuilder<ComponentNode?>(
          initialData: null,
          future: Catalog().get(context),
          builder: (context, data) {
            if (!data.hasData || data.data == null) {
              return Container();
            }
            final node = data.data as ComponentNode;
            if (treeController == null) {
              treeController = TreeController<ComponentNode>(
                roots: [node],
                childrenProvider: (ComponentNode node) => node.children.values,
              );
              if (treeController!.isTreeCollapsed) {
                treeController!.expandAll();
              }
            }
            return AnimatedTreeView<ComponentNode>(
              treeController: treeController!,
              nodeBuilder:
                  (BuildContext context, TreeEntry<ComponentNode> entry) {
                return InkWell(
                  onTap: () {
                    // _nodePressed(node);
                  },
                  child: TreeIndentation(
                    entry: entry,
                    child: Row(
                      children: [
                        FolderButton(
                          color: Colors.black,
                          isOpen: entry.hasChildren ? entry.isExpanded : null,
                          onPressed: () => _nodePressed(entry),
                        ),
                        Text(
                          entry.node.id,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: .3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  void _nodePressed(TreeEntry<ComponentNode> entry) {
    if (entry.node.children.isEmpty) {
      if (entry.node.builtComponent?.preview?.path != null) {
        context.go(
            '${CatalogComponent.routeName}/${entry.node.builtComponent!.preview!.path}');
      }
    } else {
      if (!entry.isExpanded) {
        treeController?.toggleExpansion(entry.node);
      } else {
        treeController?.collapse(entry.node);
      }
    }
  }
}
