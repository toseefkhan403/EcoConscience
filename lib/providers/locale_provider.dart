import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale locale = const Locale('en');
  late SharedPreferences _prefs;

  LocaleProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    locale = Locale(_prefs.getString('langCode') ?? 'en');

    notifyListeners();
  }

  switchLocale() {
    if (locale.languageCode == 'en') {
      locale = const Locale('ja');
    } else {
      locale = const Locale('en');
    }
    _prefs.setString('langCode', locale.languageCode);

    notifyListeners();
  }

  String getFontFamily({String englishFont = "VT323"}) {
    return locale.languageCode == 'ja' ? "Jackey" : englishFont;
  }
}
