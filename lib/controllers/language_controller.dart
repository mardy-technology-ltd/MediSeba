import 'package:flutter/material.dart';
import '../services/cache_service.dart';

enum AppLanguage { bangla, english }

class LanguageController extends ChangeNotifier {
  static const String _languageKey = 'user_app_language';
  AppLanguage _currentLanguage = AppLanguage.bangla;

  LanguageController() {
    _loadSavedLanguage();
  }

  AppLanguage get currentLanguage => _currentLanguage;
  bool get isBangla => _currentLanguage == AppLanguage.bangla;
  bool get isEnglish => _currentLanguage == AppLanguage.english;
  String get code => isBangla ? 'bn' : 'en';
  String get name => isBangla ? 'Bangla' : 'English';

  void _loadSavedLanguage() {
    try {
      final saved = CacheService.get(_languageKey);
      if (saved is String) {
        if (saved == 'en') {
          _currentLanguage = AppLanguage.english;
        } else {
          _currentLanguage = AppLanguage.bangla;
        }
        notifyListeners();
      }
    } catch (_) {}
  }

  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      CacheService.put(_languageKey, language == AppLanguage.english ? 'en' : 'bn');
      notifyListeners();
    }
  }

  void toggleLanguage() {
    if (isBangla) {
      setLanguage(AppLanguage.english);
    } else {
      setLanguage(AppLanguage.bangla);
    }
  }

  /// Translation helper
  String tr(String bnText, String enText) {
    return isBangla ? bnText : enText;
  }
}
