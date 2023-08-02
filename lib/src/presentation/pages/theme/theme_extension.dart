import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/di/injector.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';

SuggestionsTheme get theme => i.theme;

extension ThemeExtension on BuildContext {
  ThemeData get theme {
    return Theme.of(this);
  }
}
