import 'package:flutter/cupertino.dart';

import '../theme/suggestions_theme.dart';

class SuggestionsSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const SuggestionsSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      activeColor: theme.elevatedButtonColor,
      trackColor: theme.primaryBackgroundColor,
      thumbColor: value ? theme.elevatedButtonTextColor : theme.dividerColor,
      onChanged: onChanged,
    );
  }
}
