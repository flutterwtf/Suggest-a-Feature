import 'package:flutter/material.dart';
import 'package:suggest_a_feature/src/presentation/pages/theme/theme_extension.dart';
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
          child: TextButton(
            onPressed: onCancel,
            child: Text(context.localization.cancel),
          ),
        ),
        Text(
          title,
          style: context.themeData.textTheme.displayMedium,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onDone,
            child: Text(context.localization.done),
          ),
        ),
      ],
    );
  }
}
