import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nunyaexam/features/settings/settingsLocalDataSource.dart';
import 'package:nunyaexam/utils/constants.dart';
import 'package:nunyaexam/utils/uiUtils.dart';

class AppLocalizationState {
  final Locale language;
  AppLocalizationState(this.language);
}

class AppLocalizationCubit extends Cubit<AppLocalizationState> {
  final SettingsLocalDataSource settingsLocalDataSource;
  AppLocalizationCubit(this.settingsLocalDataSource)
      : super(AppLocalizationState(
            UiUtils.getLocaleFromLanguageCode(defaultLanguageCode))) {
    changeLanguage(settingsLocalDataSource.languageCode()!);
  }

  void changeLanguage(String languageCode) {
    settingsLocalDataSource.setLanguageCode(languageCode);
    emit(AppLocalizationState(UiUtils.getLocaleFromLanguageCode(languageCode)));
  }
}
