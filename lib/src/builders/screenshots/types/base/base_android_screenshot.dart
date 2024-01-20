import 'package:catalog/catalog.dart';
import 'package:catalog/src/builders/screenshots/types/base/base_screenshot.dart';

abstract class BaseAndroidScreenshot extends BaseScreenshot {
  @override
  String get imageName => '';

  @override
  String get fileName {
    final l = locale;
    if (l == null) {
      return '$index.png';
    }
    return '${index}_${l.playStoreAdapter()}.png';
  }

  BaseAndroidScreenshot({required super.index});
}
