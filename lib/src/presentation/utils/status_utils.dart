import 'package:flutter/material.dart';

import './context_utils.dart';
import '../../../suggest_a_feature.dart';

extension SuggestionStatusExtension on SuggestionStatus {
  String statusName(BuildContext context) {
    switch (this) {
      case SuggestionStatus.duplicate:
        return context.localization.duplicate;
      case SuggestionStatus.cancelled:
        return context.localization.cancelled;
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
