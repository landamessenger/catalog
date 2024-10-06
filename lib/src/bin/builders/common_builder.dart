import 'dart:io';

Future<String?> findClassName(String path) async {
  try {
    File file = File(path);
    final content = await file.readAsString();
    return '${content.split("class ")[1].split(" ").first.trim()}()';
  } catch (e) {
    print(e);
    return null;
  }
}

Future<String?> findPreviewAnnotation(String path) async {
  try {
    File file = File(path);
    final content = await file.readAsString();
    return '@Preview${content.split("@Preview")[1].split(''')
class''').first.trim()})';
  } catch (e) {
    print(e);
    return null;
  }
}
