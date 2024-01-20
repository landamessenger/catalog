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

  String? appleStoreAdapter() {
    const langSeparator = '-';

    final languageCode = toLanguageCode();

    final storeLanguages = [
      'zh-Hans',
      'cs',
      'da',
      'nl-NL',
      'en-US',
      'en-GB',
      'es-ES',
      'es-MX',
      'fi',
      'fr-FR',
      'de-DE',
      'hu',
      'id',
      'it',
      'ja',
      'ko',
      'pl',
      'pt-PT',
      'pt-BR',
      'ro',
      'ru',
      'sk',
      'sv',
      'tr',
      'uk',
    ];

    /**
     * First check
     */
    for (String l in storeLanguages) {
      if (l.toLowerCase() == languageCode.toLowerCase()) {
        return l;
      }
    }

    for (String l in storeLanguages) {
      var languageToCheck = '';
      if (l.contains(langSeparator)) {
        languageToCheck = l.split(langSeparator).first.toLowerCase();
      } else {
        languageToCheck = l.toLowerCase();
      }

      var lc = '';
      if (languageCode.contains(langSeparator)) {
        lc = languageCode.split(langSeparator).first.toLowerCase();
      } else {
        lc = languageCode.toLowerCase();
      }

      if (languageToCheck == lc) {
        return l;
      }
    }

    return null;
  }

  String? playStoreAdapter() {
    const langSeparator = '-';

    final languageCode = toLanguageCode();

    final storeLanguages = [
      'bg',
      'zh-CN',
      'cs-CZ',
      'da-DK',
      'nl-NL',
      'es-ES',
      'en-US',
      'en-GB',
      'et',
      'fi-FI',
      'fr-FR',
      'de-DE',
      'hu-HU',
      'id',
      'it-IT',
      'ja-JP',
      'ko-KR',
      'lv',
      'lt',
      'pl-PL',
      'pt-PT',
      'pt-BR',
      'ro',
      'ru-RU',
      'sk',
      'sl',
      'sv-SE',
      'tr-TR',
      'uk',
    ];

    /**
     * First check
     */
    for (String l in storeLanguages) {
      if (l.toLowerCase() == languageCode.toLowerCase()) {
        return l;
      }
    }

    for (String l in storeLanguages) {
      var languageToCheck = '';
      if (l.contains(langSeparator)) {
        languageToCheck = l.split(langSeparator).first.toLowerCase();
      } else {
        languageToCheck = l.toLowerCase();
      }

      var lc = '';
      if (languageCode.contains(langSeparator)) {
        lc = languageCode.split(langSeparator).first.toLowerCase();
      } else {
        lc = languageCode.toLowerCase();
      }

      if (languageToCheck == lc) {
        return l;
      }
    }

    return null;
  }
}
