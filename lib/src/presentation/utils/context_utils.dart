import 'package:flutter/material.dart';
import 'package:suggest_a_feature/suggest_a_feature.dart';

extension ContextExtensions on BuildContext {
  SuggestionsLocalizations get localization =>
      SuggestionsLocalizations.of(this)!;
}
