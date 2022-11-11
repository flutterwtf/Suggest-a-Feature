import 'package:flutter/material.dart';

import './context_utils.dart';
import '../../../suggest_a_feature.dart';

extension SuggestionLabelExtension on SuggestionLabel {
  Color labelColor() {
    switch (this) {
      case SuggestionLabel.feature:
        return theme.featureLabelColor;
      case SuggestionLabel.bug:
        return theme.bugLabelColor;
    }
  }

  String labelName(BuildContext context) {
    switch (this) {
      case SuggestionLabel.feature:
        return context.localization.feature;
      case SuggestionLabel.bug:
        return context.localization.bug;
    }
  }
}
