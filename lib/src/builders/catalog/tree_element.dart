import 'package:catalog/src/builders/catalog/built_component.dart';

class TreeElement {
  BuiltComponent? component;
  List<TreeElement> children = [];

  TreeElement();
}
