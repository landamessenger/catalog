import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerPreview extends StatefulWidget {
  final void Function()? onBackPressed;

  const DrawerPreview({
    super.key,
    this.onBackPressed,
  });

  @override
  DrawerPreviewState createState() => DrawerPreviewState();
}

class DrawerPreviewState extends State<DrawerPreview> {
  ComponentNode? node;
  TreeController<ComponentNode>? treeController;

  @override
  void initState() {
    super.initState();
    Catalog().get(context).then((value) {
      if (value == null) return;
      node = value;
      if (treeController == null) {
        treeController = TreeController<ComponentNode>(
          roots: [value],
          childrenProvider: (ComponentNode node) => node.children.values,
        );
        if (treeController!.isTreeCollapsed) {
          treeController!.expandAll();
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (node == null || treeController == null) {
      return Container();
    }
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: 600,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (widget.onBackPressed != null) {
                      widget.onBackPressed!();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),
                const Text(
                  'Catalog',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: .3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height - 200,
            child: AnimatedTreeView<ComponentNode>(
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
                          isOpen: entry.hasChildren ? entry.isExpanded : null,
                          onPressed: () => _nodePressed(node!, entry),
                        ),
                        Text(
                          entry.node.id,
                          style: const TextStyle(
                            fontSize: 16,
                            letterSpacing: .3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _nodePressed(ComponentNode baseNode, TreeEntry<ComponentNode> entry) {
    if (entry.node.children.isEmpty) {
      if (entry.node.builtComponent?.preview?.path != null) {
        context
            .go('/${baseNode.id}/${entry.node.builtComponent!.preview!.path}');
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
