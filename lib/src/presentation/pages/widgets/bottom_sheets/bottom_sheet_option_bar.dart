import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/suggestions_theme.dart';
import 'package:suggest_a_feature/src/presentation/pages/widgets/suggestions_text_button.dart';
import 'package:suggest_a_feature/src/presentation/utils/context_utils.dart';

class BottomSheetOptionBar extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  const BottomSheetOptionBar({
    required this.title,
    required this.onCancel,
    required this.onDone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: SuggestionsTextButton(
            title: context.localization.cancel,
            onClick: onCancel,
          ),
        ),
        Text(title, style: theme.textMediumPlusBold),
        Align(
          alignment: Alignment.centerRight,
          child: SuggestionsTextButton(
            title: context.localization.done,
            onClick: onDone,
          ),
        ),
      ],
    );
  }
}
