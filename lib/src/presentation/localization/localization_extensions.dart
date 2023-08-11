import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_options.dart';

extension LanguageCodeExtension on String {
  LocalizationOptions get localizationOptions {
    return switch (this) {
      'en' => LocalizationOptions.en(),
      'ru' => LocalizationOptions.ru(),
      'uk' => LocalizationOptions.uk(),
      _ => LocalizationOptions.en(),
    };
  }
}

LocalizationOptions get localization => i.localizations;
