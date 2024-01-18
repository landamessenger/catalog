import 'dart:ui';

extension LocaleExt on Locale {
  String toLanguageCode() {
    var language = languageCode.toLowerCase();
    final country = countryCode;
    if (country != null) {
      language += '-${country.toUpperCase()}';
    }
    return language;
  }
}
