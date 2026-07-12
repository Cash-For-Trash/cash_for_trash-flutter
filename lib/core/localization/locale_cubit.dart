import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  static const String _localeKey = 'app_locale';

  void _loadSavedLocale() {
    final dynamic savedLocale = CacheHelper.getData(key: _localeKey);
    if (savedLocale != null && savedLocale is String) {
      emit(Locale(savedLocale));
    }
  }

  void changeLocale(String languageCode) {
    CacheHelper.saveData(key: _localeKey, value: languageCode);
    emit(Locale(languageCode));
  }
}
