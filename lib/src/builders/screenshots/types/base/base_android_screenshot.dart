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

    var language = l.languageCode.toLowerCase();
    final country = l.countryCode;
    if (country != null) {
      language += '-${country.toUpperCase()}';
    }

    return '${index}_$language.png';
  }

  BaseAndroidScreenshot({required super.index});
}
