import 'package:flutter/widgets.dart';

import '../../../suggest_a_feature.dart';

extension ContextExtensions on BuildContext {
  SuggestionsLocalizations get localization => SuggestionsLocalizations.of(this)!;
}
