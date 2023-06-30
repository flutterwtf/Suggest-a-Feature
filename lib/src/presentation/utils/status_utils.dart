import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

extension SuggestionStatusExtension on SuggestionStatus {
  String statusName(BuildContext context) {
    switch (this) {
      case SuggestionStatus.duplicate:
        return context.localization.duplicated;
      case SuggestionStatus.cancelled:
        return context.localization.declined;
      case SuggestionStatus.requests:
        return context.localization.requests;
      case SuggestionStatus.inProgress:
        return context.localization.inProgress;
      case SuggestionStatus.completed:
        return context.localization.completed;
      case SuggestionStatus.unknown:
        return '';
    }
  }
}
