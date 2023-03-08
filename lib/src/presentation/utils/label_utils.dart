import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

extension SuggestionLabelExtension on SuggestionLabel {
  Color labelColor() {
    switch (this) {
      case SuggestionLabel.feature:
        return theme.featureLabelColor;
      case SuggestionLabel.bug:
        return theme.bugLabelColor;
      case SuggestionLabel.unknown:
        return theme.errorColor;
    }
  }

  String labelName(BuildContext context) {
    switch (this) {
      case SuggestionLabel.feature:
        return context.localization.feature;
      case SuggestionLabel.bug:
        return context.localization.bug;
      case SuggestionLabel.unknown:
        return context.localization.bug;
    }
  }
}
