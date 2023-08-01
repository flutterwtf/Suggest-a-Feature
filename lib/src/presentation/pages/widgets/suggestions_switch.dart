import 'package:flutter/cupertino.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';

class SuggestionsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SuggestionsSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      activeColor: theme.accentColor,
      trackColor: theme.primaryBackgroundColor,
      thumbColor: value ? theme.onAccentColor : theme.dividerColor,
      onChanged: onChanged,
    );
  }
}
