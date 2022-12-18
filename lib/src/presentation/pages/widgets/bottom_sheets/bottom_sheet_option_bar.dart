import 'package:flutter/material.dart';

import '../../../utils/context_utils.dart';
import '../../theme/suggestions_theme.dart';
import '../text_button.dart';

class BottomSheetOptionBar extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  const BottomSheetOptionBar({
    required this.title,
    required this.onCancel,
    required this.onDone,
    Key? key,
  }) : super(key: key);

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
        )
      ],
    );
  }
}
