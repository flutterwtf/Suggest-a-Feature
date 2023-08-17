import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

extension SuggestionStatusExtension on SuggestionStatus {
  String get statusName {
    switch (this) {
      case SuggestionStatus.duplicated:
        return localization.duplicated;
      case SuggestionStatus.declined:
        return localization.declined;
      case SuggestionStatus.requests:
        return localization.requests;
      case SuggestionStatus.inProgress:
        return localization.inProgress;
      case SuggestionStatus.completed:
        return localization.completed;
      case SuggestionStatus.unknown:
        return '';
    }
  }
}
