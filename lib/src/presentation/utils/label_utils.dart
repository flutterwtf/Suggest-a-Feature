import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/localization/localization_extensions.dart';
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

  String get labelName {
    switch (this) {
      case SuggestionLabel.feature:
        return localization.feature;
      case SuggestionLabel.bug:
        return localization.bug;
      case SuggestionLabel.unknown:
        return localization.bug;
    }
  }
}
