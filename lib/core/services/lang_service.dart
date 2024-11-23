import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageService with ChangeNotifier {
  String? _selectedLanguage;
  String? get selectedLanguage => _selectedLanguage;
  onchangeLangauge(BuildContext context, value) {
    _selectedLanguage = value;
    context.setLocale(Locale(value));
    notifyListeners();
  }
}
