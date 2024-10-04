import 'package:catalog/src/annotations/preview.dart';
import 'package:catalog/src/base/serial.dart';

class BuiltComponent extends Serial<BuiltComponent> {
  String path = '';
  String route = '';
  String package = '';
  String clazzName = '';
  Preview? preview;

  String get name {
    if (!path.contains('/')) return path;
    var parts = path.split('/');
    return parts.last;
  }

  BuiltComponent({
    this.path = '',
    this.route = '',
    this.package = '',
    this.clazzName = '',
    this.preview,
  });

  @override
  String getId() => route;

  @override
  BuiltComponent instance() => BuiltComponent();

  @override
  BuiltComponent fromJson(Map<String, dynamic> json) {
    path = json['path'] ?? '';
    route = json['route'] ?? '';
    package = json['package'] ?? '';
    clazzName = json['clazzName'] ?? '';
    if (json['preview'] != null) {
      preview = const Preview(id: '', path: '').fromJson(json['preview'] ?? {});
    }
    return this;
  }

  @override
  Map<String, dynamic> toJson() => {
        'path': path,
        'route': route,
        'package': package,
        'clazzName': clazzName,
        'preview': preview?.toJson(),
      };
}
