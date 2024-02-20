import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void switchLocale() {
    if (locale.languageCode == 'en') {
      _locale = const Locale('ja');
    } else {
      _locale = const Locale('en');
    }

    notifyListeners();
  }
}
